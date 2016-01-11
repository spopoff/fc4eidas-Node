/*
 * This work is Open Source and licensed by the European Commission under the
 * conditions of the European Public License v1.1
 *
 * (http://www.osor.eu/eupl/european-union-public-licence-eupl-v.1.1);
 *
 * any use of this file implies acceptance of the conditions of this license.
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,  WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations
 * under the License.
 */
package eu.eidas.node.auth.metadata;
import com.hazelcast.config.Config;
import com.hazelcast.core.Hazelcast;
import com.hazelcast.core.HazelcastInstance;

import java.util.Map;
import java.util.concurrent.ConcurrentMap;

import org.opensaml.xml.signature.SignableXMLObject;

/**
 * implements a caching service using hazelcast
 */
public class DistributedMetadataCaching extends AbstractMetadataCaching {
    private static final String METADATA_CACHE="eidasmetadata";
    private ConcurrentMap<String, SerializedEntityDescriptor> map=createMap();
    private String mapName = METADATA_CACHE;
    private String hazelcastXmlConfigClassPathFileName;

    public DistributedMetadataCaching(){
        super();
    }
    protected Map<String, SerializedEntityDescriptor> getMap(){
        return map;
    }

    private synchronized ConcurrentMap<String, SerializedEntityDescriptor> createMap(){
        ConcurrentMap<String, SerializedEntityDescriptor> map=null;
        Config config = new Config();
        HazelcastInstance h = Hazelcast.newHazelcastInstance(config);
        map = h.getMap(mapName);
        if(map!=null && !map.isEmpty()) {
            map.clear();
        }
        return map;

    }

    public String getMapName() {
        return mapName;
    }

    public void setMapName(String mapName) {
        this.mapName = mapName;
    }

    public String getHazelcastXmlConfigClassPathFileName() {
        return hazelcastXmlConfigClassPathFileName;
    }

    public void setHazelcastXmlConfigClassPathFileName(String hazelcastXmlConfigClassPathFileName) {
        this.hazelcastXmlConfigClassPathFileName = hazelcastXmlConfigClassPathFileName;
    }
}

From: akpm@linux-foundation.org
Subject: [alternative-merged]
 init-replace-fsf-address-with-web-source-in-license-notices.patch removed
 from -mm tree
Date: Wed, 15 Nov 2017 10:52:41 -0800
Message-ID: <20171115185241.kreRf6JsD%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:54808 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753230AbdKOSwm (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 15 Nov 2017 13:52:42 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, mm-commits@vger.kernel.org


The patch titled
     Subject: init: replace FSF address with web source in license notices
has been removed from the -mm tree.  Its filename was
     init-replace-fsf-address-with-web-source-in-license-notices.patch

This patch was dropped because an alternative patch was merged

------------------------------------------------------
From: Martin Kepplinger <martink@posteo.de>
Subject: init: replace FSF address with web source in license notices

A few years ago the FSF moved and "59 Temple Place" is wrong.  Having this
still in our source files feels old and unmaintained.

Let's take the license statement serious and not confuse users.

As https://www.gnu.org/licenses/gpl-howto.html suggests, we replace the
postal address with "<http://www.gnu.org/licenses/>".

Link: http://lkml.kernel.org/r/20171114092913.27255-1-martink@posteo.de
Signed-off-by: Martin Kepplinger <martink@posteo.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/noinitramfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -puN init/noinitramfs.c~init-replace-fsf-address-with-web-source-in-license-notices init/noinitramfs.c
--- a/init/noinitramfs.c~init-replace-fsf-address-with-web-source-in-license-notices
+++ a/init/noinitramfs.c
@@ -14,8 +14,7 @@
  * GNU General Public License for more details.
  *
  * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
  */
 #include <linux/init.h>
 #include <linux/stat.h>
_

Patches currently in -mm which might be from martink@posteo.de are

lib-replace-fsf-address-with-web-source-in-license-notices.patch


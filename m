From: akpm@linux-foundation.org
Subject: +
 init-replace-fsf-address-with-web-source-in-license-notices.patch added to
 -mm tree
Date: Tue, 14 Nov 2017 15:59:24 -0800
Message-ID: <5a0b835c.wSU8xoQZ5RaR6lhT%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47556 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754110AbdKNX7Z (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 14 Nov 2017 18:59:25 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: martink@posteo.de, mm-commits@vger.kernel.org


The patch titled
     Subject: init: replace FSF address with web source in license notices
has been added to the -mm tree.  Its filename is
     init-replace-fsf-address-with-web-source-in-license-notices.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-replace-fsf-address-with-web-source-in-license-notices.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-replace-fsf-address-with-web-source-in-license-notices.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

samples-replace-fsf-address-with-web-source-in-license-notices.patch
scripts-replace-fsf-address-with-web-source-in-license-notices.patch
kernel-replace-fsf-address-with-web-source-in-license-notices.patch
init-replace-fsf-address-with-web-source-in-license-notices.patch
lib-replace-fsf-address-with-web-source-in-license-notices.patch


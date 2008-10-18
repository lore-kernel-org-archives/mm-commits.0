From: akpm@linux-foundation.org
Subject: - quota-remove-cvs-keywords.patch removed from -mm tree
Date: Sat, 18 Oct 2008 16:18:46 -0700
Message-ID: <200810182318.m9INIk25029338@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54856 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752186AbYJRXS6 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sat, 18 Oct 2008 19:18:58 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: bunk@kernel.org, jack@suse.cz, mm-commits@vger.kernel.org


The patch titled
     quota: remove CVS keywords
has been removed from the -mm tree.  Its filename was
     quota-remove-cvs-keywords.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: quota: remove CVS keywords
From: Adrian Bunk <bunk@kernel.org>

Remove CVS keywords that weren't updated for a long time from comments.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Jan Kara <jack@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/dquot.c               |    2 --
 include/linux/quota.h    |    2 --
 include/linux/quotaops.h |    3 ---
 3 files changed, 7 deletions(-)

diff -puN fs/dquot.c~quota-remove-cvs-keywords fs/dquot.c
--- a/fs/dquot.c~quota-remove-cvs-keywords
+++ a/fs/dquot.c
@@ -9,8 +9,6 @@
  * implementation is based on one of the several variants of the LINUX
  * inode-subsystem with added complexity of the diskquota system.
  * 
- * Version: $Id: dquot.c,v 6.3 1996/11/17 18:35:34 mvw Exp mvw $
- * 
  * Author:	Marco van Wieringen <mvw@planets.elm.net>
  *
  * Fixes:   Dmitry Gorodchanin <pgmdsg@ibi.com>, 11 Feb 96
diff -puN include/linux/quota.h~quota-remove-cvs-keywords include/linux/quota.h
--- a/include/linux/quota.h~quota-remove-cvs-keywords
+++ a/include/linux/quota.h
@@ -28,8 +28,6 @@
  * LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
  * OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
  * SUCH DAMAGE.
- *
- * Version: $Id: quota.h,v 2.0 1996/11/17 16:48:14 mvw Exp mvw $
  */
 
 #ifndef _LINUX_QUOTA_
diff -puN include/linux/quotaops.h~quota-remove-cvs-keywords include/linux/quotaops.h
--- a/include/linux/quotaops.h~quota-remove-cvs-keywords
+++ a/include/linux/quotaops.h
@@ -3,9 +3,6 @@
  * macros expand to the right source-code.
  *
  * Author:  Marco van Wieringen <mvw@planets.elm.net>
- *
- * Version: $Id: quotaops.h,v 1.2 1998/01/15 16:22:26 ecd Exp $
- *
  */
 #ifndef _LINUX_QUOTAOPS_
 #define _LINUX_QUOTAOPS_
_

Patches currently in -mm which might be from bunk@kernel.org are

origin.patch
make-probe_serial_gsc-static.patch
make-ptrace_untrace-static.patch
make-mm-rmapc-anon_vma_cachep-static.patch
acpi-use-bcd2bin-bin2bcd.patch
alpha-use-bcd2bin-bin2bcd.patch
cris-use-bcd2bin-bin2bcd.patch
drivers-rtc-use-bcd2bin-bin2bcd.patch
rtc-use-bcd2bin-bin2bcd.patch
mips-use-bcd2bin-bin2bcd.patch
mn10300-use-bcd2bin-bin2bcd.patch
i2c-use-bcd2bin-bin2bcd.patch
drivers-scsi-sr_vendorc-use-bcd2bin.patch
remove-the-obsolete-bcdbin-binbcd-macros.patch
include-linux-bcdh-remove-comments.patch


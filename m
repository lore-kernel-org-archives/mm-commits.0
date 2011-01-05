From: akpm@linux-foundation.org
Subject: [merged] fs-9p-fix-menu-presentation.patch removed from -mm tree
Date: Wed, 05 Jan 2011 11:28:28 -0800
Message-ID: <201101051930.p05JU3vT014070@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35042 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751523Ab1AETaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 5 Jan 2011 14:30:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: randy.dunlap@oracle.com, ericvh@gmail.com, lucho@ionkov.net, rminnich@sandia.gov, mm-commits@vger.kernel.org


The patch titled
     fs/9p: fix menu presentation
has been removed from the -mm tree.  Its filename was
     fs-9p-fix-menu-presentation.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: fs/9p: fix menu presentation
From: Randy Dunlap <randy.dunlap@oracle.com>

Make the 9P_FS kconfig options subordinate to the 9P_FS kconfig symbol in
the menu presentation instead of them all being at the same level.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Eric Van Hensbergen <ericvh@gmail.com>
Cc: Ron Minnich <rminnich@sandia.gov>
Cc: Latchesar Ionkov <lucho@ionkov.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/9p/Kconfig |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff -puN fs/9p/Kconfig~fs-9p-fix-menu-presentation fs/9p/Kconfig
--- a/fs/9p/Kconfig~fs-9p-fix-menu-presentation
+++ a/fs/9p/Kconfig
@@ -9,6 +9,8 @@ config 9P_FS
 
 	  If unsure, say N.
 
+if 9P_FS
+
 config 9P_FSCACHE
 	bool "Enable 9P client caching support (EXPERIMENTAL)"
 	depends on EXPERIMENTAL
@@ -20,7 +22,6 @@ config 9P_FSCACHE
 
 config 9P_FS_POSIX_ACL
 	bool "9P POSIX Access Control Lists"
-	depends on 9P_FS
 	select FS_POSIX_ACL
 	help
 	  POSIX Access Control Lists (ACLs) support permissions for users and
@@ -30,3 +31,5 @@ config 9P_FS_POSIX_ACL
 	  Linux website <http://acl.bestbits.at/>.
 
 	  If you don't know what Access Control Lists are, say N
+
+endif
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

linux-next.patch
backlight-fix-88pm860x_bl-macro-collision.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
uml-mmapper_kern-needs-module_license.patch
kernel-clean-up-use_generic_smp_helpers.patch
kptr_restrict-fix-build-when-printk-not-enabled.patch
fs-fs_posix_acl-does-not-depend-on-block.patch
gpio_rdc321x-select-mfd_support-to-squelch-kconfig-warning.patch
gpio_vx855-eliminate-kconfig-dependency-warning.patch
documentation-email-clientstxt-warn-about-word-wrap-bug-in-kmail.patch
memstick-factor-out-transfer-initiating-functionality-in-mspro_blockc-fix.patch
w1-ds2423-counter-driver-and-documentation-fix.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch


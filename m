From: akpm@linux-foundation.org
Subject: [folded-merged]
 drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch removed from
 -mm tree
Date: Tue, 12 Nov 2013 14:43:53 -0800
Message-ID: <5282af29.qXuWSsMCH+fQFQO9%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60925 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756613Ab3KLWny (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 12 Nov 2013 17:43:54 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ldewangan@nvidia.com, florian.lobmaier@ams.com, akpm@linux-foundation.org

Subject: [folded-merged] drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch removed from -mm tree
To: akpm@linux-foundation.org,florian.lobmaier@ams.com,ldewangan@nvidia.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 12 Nov 2013 14:43:53 -0800


The patch titled
     Subject: drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch

This patch was dropped because it was folded into drivers-rtc-rtc-as3722-add-rtc-driver.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes

ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
#76: FILE: drivers/rtc/rtc-as3722.c:20:
+ * You should have received a copy of the GNU General Public License$

ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
#77: FILE: drivers/rtc/rtc-as3722.c:21:
+ * along with this program; if not, write to the Free Software$

ERROR: Do not include the paragraph about writing to the Free Software Foundation's mailing address from the sample GPL notice. The FSF has changed addresses in the past, and may do so again. Linux already includes a copy of the GPL.
#78: FILE: drivers/rtc/rtc-as3722.c:22:
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA$

total: 3 errors, 0 warnings, 303 lines checked

./patches/drivers-rtc-rtc-as3722-add-rtc-driver.patch has style problems, please review.

If any of these errors are false positives, please report
them to the maintainer, see CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Florian Lobmaier <florian.lobmaier@ams.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-as3722.c |    5 -----
 1 file changed, 5 deletions(-)

diff -puN drivers/rtc/rtc-as3722.c~drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes drivers/rtc/rtc-as3722.c
--- a/drivers/rtc/rtc-as3722.c~drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes
+++ a/drivers/rtc/rtc-as3722.c
@@ -16,11 +16,6 @@
  * but WITHOUT ANY WARRANTY; without even the implied warranty of
  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- *
  */
 
 #include <linux/bcd.h>
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
mm-thp-khugepaged-add-policy-for-finding-target-node.patch
mm-factor-commit-limit-calculation.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs.patch
drivers-rtc-rtc-as3722-add-rtc-driver.patch
fs-hfs-btreeh-remove-duplicate-defines-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch


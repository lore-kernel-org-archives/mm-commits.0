From: akpm@linux-foundation.org
Subject: + drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
 added to -mm tree
Date: Tue, 05 Nov 2013 15:34:34 -0800
Message-ID: <5279808a.oAk9QJvrMQpt0v4r%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59394 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3KEXef (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 5 Nov 2013 18:34:35 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, ldewangan@nvidia.com, florian.lobmaier@ams.com, akpm@linux-foundation.org

Subject: + drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch added to -mm tree
To: akpm@linux-foundation.org,florian.lobmaier@ams.com,ldewangan@nvidia.com
From: akpm@linux-foundation.org
Date: Tue, 05 Nov 2013 15:34:34 -0800


The patch titled
     Subject: drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
mm-readaheadc-do_readhead-dont-check-for-readpage.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
mm-thp-khugepaged-add-policy-for-finding-target-node-fix.patch
kernel-printk-printkc-convert-to-pr_foo.patch
maintainers-remove-richard-purdie-as-backlight-maintainer-fix.patch
checkpatch-extend-camelcase-types-and-ignore-existing-camelcase-uses-in-a-patch.patch
checkpatch-add-test-for-defines-of-arch_has_foo.patch
epoll-do-not-take-global-epmutex-for-simple-topologies-fix.patch
binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
init-do_mounts_rdc-fix-null-pointer-dereference-while-loading-initramfs-fix.patch
drivers-rtc-rtc-as3722-add-rtc-driver-checkpatch-fixes.patch
gcov-add-support-for-gcc-47-gcov-format-fix.patch
gcov-add-support-for-gcc-47-gcov-format-fix-fix.patch
gcov-add-support-for-gcc-47-gcov-format-checkpatch-fixes.patch
kernel-modulec-use-pr_foo.patch
kernel-gcov-fsc-use-pr_warn.patch
kfifo-api-type-safety-checkpatch-fixes.patch
ipc-msg-fix-message-length-check-for-negative-values-fix.patch
linux-next.patch
linux-next-rejects.patch
x86-mem-hotplug-support-initialize-page-tables-in-bottom-up-next-fix.patch
net-netfilter-ipset-ip_set_hash_netnetc-fix-build-with-older-gcc.patch
net-netfilter-ipset-ip_set_hash_netportnetc-fix-build-with-older-gccs.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
mm-hugetlb-convert-hugetlbfs-to-use-split-pmd-lock-checkpatch-fixes.patch
x86-mm-enable-split-page-table-lock-for-pmd-level-checkpatch-fixes.patch
mm-dynamically-allocate-page-ptl-if-it-cannot-be-embedded-to-struct-page-fix-fix.patch
tree-wide-use-reinit_completion-instead-of-init_completion-fix.patch
kernel-provide-a-__smp_call_function_single-stub-for-config_smp-fix.patch
llists-move-llist_reverse_order-from-raid5-to-llistc-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch


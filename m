From: akpm@linux-foundation.org
Subject: [to-be-updated] ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch removed from -mm tree
Date: Tue, 16 Jun 2009 15:41:29 -0700
Message-ID: <200906162241.n5GMfT0b003529@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33411 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754466AbZFPWnQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 16 Jun 2009 18:43:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ieidus@redhat.com, aarcange@redhat.com, avi@redhat.com, chrisw@redhat.com, device@lanana.org, hugh.dickins@tiscali.co.uk, nickpiggin@yahoo.com.au, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     ksm: use another miscdevice minor number.
has been removed from the -mm tree.  Its filename was
     ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch

This patch was dropped because an updated version will be merged

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: ksm: use another miscdevice minor number.
From: Izik Eidus <ieidus@redhat.com>

The old number was registered already by another project.
The new number is #234.

Signed-off-by: Izik Eidus <ieidus@redhat.com>
Signed-off-by: Alan Cox <device@lanana.org>
Cc: Chris Wright <chrisw@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Avi Kivity <avi@redhat.com>
Cc: Hugh Dickins <hugh@veritas.com>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/devices.txt  |    1 +
 include/linux/miscdevice.h |    2 +-
 2 files changed, 2 insertions(+), 1 deletion(-)

diff -puN Documentation/devices.txt~ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number Documentation/devices.txt
--- a/Documentation/devices.txt~ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number
+++ a/Documentation/devices.txt
@@ -443,6 +443,7 @@ Your cooperation is appreciated.
 		231 = /dev/snapshot	System memory snapshot device
 		232 = /dev/kvm		Kernel-based virtual machine (hardware virtualization extensions)
 		233 = /dev/kmview	View-OS A process with a view
+		234 = /dev/ksm		Dynamic page sharing
 		240-254			Reserved for local use
 		255			Reserved for MISC_DYNAMIC_MINOR
 
diff -puN include/linux/miscdevice.h~ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number include/linux/miscdevice.h
--- a/include/linux/miscdevice.h~ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number
+++ a/include/linux/miscdevice.h
@@ -30,7 +30,7 @@
 #define HPET_MINOR		228
 #define FUSE_MINOR		229
 #define KVM_MINOR		232
-#define KSM_MINOR		233
+#define KSM_MINOR		234
 #define MISC_DYNAMIC_MINOR	255
 
 struct device;
_

Patches currently in -mm which might be from ieidus@redhat.com are

linux-next.patch
ksm-add-ksm-kernel-shared-memory-driver-use-another-miscdevice-minor-number.patch
ksm-add-ksm-kernel-shared-memory-driver-ksm-fix-rmap_item-use-after-free.patch
ksm-add-replace_page-change-the-page-pte-is-pointing-to-fix-losing-visibility-of-part-of-rmap_item-next-list.patch


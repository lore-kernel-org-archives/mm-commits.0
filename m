From: akpm@linux-foundation.org
Subject: [merged] kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch removed from -mm tree
Date: Sun, 17 May 2009 09:54:20 -0700
Message-ID: <200905171654.n4HGsKMe017057@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57292 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753042AbZEQQzK (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Sun, 17 May 2009 12:55:10 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@crashcourse.ca, avi@redhat.com, mm-commits@vger.kernel.org


The patch titled
     kvm: expand on "help" info to specify kvm intel and amd module names
has been removed from the -mm tree.  Its filename was
     kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kvm: expand on "help" info to specify kvm intel and amd module names
From: "Robert P. J. Day" <rpjday@crashcourse.ca>

Signed-off-by: Robert P. J. Day <rpjday@crashcourse.ca>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/Kconfig |    6 ++++++
 1 file changed, 6 insertions(+)

diff -puN arch/x86/kvm/Kconfig~kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names arch/x86/kvm/Kconfig
--- a/arch/x86/kvm/Kconfig~kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names
+++ a/arch/x86/kvm/Kconfig
@@ -50,6 +50,9 @@ config KVM_INTEL
 	  Provides support for KVM on Intel processors equipped with the VT
 	  extensions.
 
+	  To compile this as a module, choose M here: the module
+	  will be called kvm-intel.
+
 config KVM_AMD
 	tristate "KVM for AMD processors support"
 	depends on KVM
@@ -57,6 +60,9 @@ config KVM_AMD
 	  Provides support for KVM on AMD processors equipped with the AMD-V
 	  (SVM) extensions.
 
+	  To compile this as a module, choose M here: the module
+	  will be called kvm-amd.
+
 config KVM_TRACE
 	bool "KVM trace support"
 	depends on KVM && SYSFS
_

Patches currently in -mm which might be from rpjday@crashcourse.ca are

linux-next.patch
drm-simplify-kcalloc-call-to-kzalloc.patch
scripts-headers_checkpl-correct-re-in-header-config-leak-check.patch
ramdisk-remove-long-deprecated-ramdisk=-boot-time-param.patch
kernel-kfifoc-replace-conditional-test-with-is_power_of_2.patch
ntfs-use-is_power_of_2-function-for-clarity.patch


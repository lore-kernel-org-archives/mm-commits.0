From: akpm@linux-foundation.org
Subject: + kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch added to -mm tree
Date: Thu, 09 Apr 2009 14:25:58 -0700
Message-ID: <200904092125.n39LPwE7001870@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934556AbZDIV23 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Apr 2009 17:28:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@crashcourse.ca, avi@redhat.com


The patch titled
     kvm: expand on "help" info to specify kvm intel and amd module names
has been added to the -mm tree.  Its filename is
     kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

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

kvm-expand-on-help-info-to-specify-kvm-intel-and-amd-module-names.patch


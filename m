From: akpm@linux-foundation.org
Subject: + kvm-fix-build-error-add-missing-semi-colon.patch added to -mm tree
Date: Mon, 11 May 2009 16:46:21 -0700
Message-ID: <200905112346.n4BNkLU1026958@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48267 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760275AbZEKXtQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 11 May 2009 19:49:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: randy.dunlap@oracle.com, avi@redhat.com, sfr@canb.auug.org.au


The patch titled
     kvm: fix build error: add missing semi-colon
has been added to the -mm tree.  Its filename is
     kvm-fix-build-error-add-missing-semi-colon.patch

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
Subject: kvm: fix build error: add missing semi-colon
From: Randy Dunlap <randy.dunlap@oracle.com>

Add missing ; to fix build error:

arch/x86/kvm/x86.c:1259: error: expected',' or ';' before 'const'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Avi Kivity <avi@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kvm/x86.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kvm/x86.c~kvm-fix-build-error-add-missing-semi-colon arch/x86/kvm/x86.c
--- a/arch/x86/kvm/x86.c~kvm-fix-build-error-add-missing-semi-colon
+++ a/arch/x86/kvm/x86.c
@@ -1252,7 +1252,7 @@ static void do_cpuid_ent(struct kvm_cpui
 #ifdef CONFIG_X86_64
 	unsigned f_lm = F(LM);
 #else
-	unsigned f_lm = 0
+	unsigned f_lm = 0;
 #endif
 
 	/* cpuid 1.edx */
_

Patches currently in -mm which might be from randy.dunlap@oracle.com are

origin.patch
linux-next.patch
kvm-fix-build-error-add-missing-semi-colon.patch
dm-table-fix-printk-formats.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-fix.patch
input-drivers-input-xpadc-improve-xbox-360-wireless-support-and-add-sysfs-interface-add-missing-prototype-and-update-history.patch
menu-fix-embedded-menu-presentation.patch
e1000e-make-e1000e-default-to-the-same-kconfig-setting-as-e1000.patch
qla2x-fix-printk-format-warnings.patch
slqbinfo-eliminate-warnings.patch
lockd-fix-file_locking=n-build-error.patch
xen-use-header-for-export_symbol_gpl.patch
kmap_types-make-most-arches-use-generic-header-file.patch
irqs-add-irqf_sample_random-to-the-feature-removal-scheduletxt-deprecated-list.patch
cgroups-make-messages-more-readable.patch
linuxpps-core-support.patch
reiser4-export-remove_from_page_cache-fix.patch


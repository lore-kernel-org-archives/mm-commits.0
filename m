From: akpm@linux-foundation.org
Subject: + cpufreq-make-cpufreq-nforce2-less-obnoxious.patch added to -mm tree
Date: Tue, 24 Feb 2009 11:58:22 -0800
Message-ID: <200902241958.n1OJwMbM006405@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:35418 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182AbZBXT71 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 24 Feb 2009 14:59:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mjg59@srcf.ucam.org, mjg@redhat.com


The patch titled
     cpufreq: make cpufreq-nforce2 less obnoxious
has been added to the -mm tree.  Its filename is
     cpufreq-make-cpufreq-nforce2-less-obnoxious.patch

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
Subject: cpufreq: make cpufreq-nforce2 less obnoxious
From: Matthew Garrett <mjg59@srcf.ucam.org>

Not owning an nforce2 is a sign of good taste, not an error.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c~cpufreq-make-cpufreq-nforce2-less-obnoxious arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
--- a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c~cpufreq-make-cpufreq-nforce2-less-obnoxious
+++ a/arch/x86/kernel/cpu/cpufreq/cpufreq-nforce2.c
@@ -420,7 +420,7 @@ static int __init nforce2_init(void)
 
 	/* detect chipset */
 	if (nforce2_detect_chipset()) {
-		printk(KERN_ERR "cpufreq: No nForce2 chipset.\n");
+		printk(KERN_INFO "cpufreq: No nForce2 chipset.\n");
 		return -ENODEV;
 	}
 
_

Patches currently in -mm which might be from mjg59@srcf.ucam.org are

serial-update-pnp-ids.patch
cpufreq-make-cpufreq-nforce2-less-obnoxious.patch


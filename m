From: akpm@linux-foundation.org
Subject: [merged] cpufreq-make-cpufreq-nforce2-less-obnoxious.patch removed from -mm tree
Date: Thu, 26 Feb 2009 11:30:21 -0800
Message-ID: <200902261930.n1QJULoY014413@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59206 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082AbZBZTao (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 26 Feb 2009 14:30:44 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mjg59@srcf.ucam.org, mjg@redhat.com, mm-commits@vger.kernel.org


The patch titled
     cpufreq: make cpufreq-nforce2 less obnoxious
has been removed from the -mm tree.  Its filename was
     cpufreq-make-cpufreq-nforce2-less-obnoxious.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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
linux-next.patch


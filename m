From: akpm@linux-foundation.org
Subject: + drivers-idle-intel_idlec-fix-confusing-code-identation.patch added to -mm tree
Date: Fri, 02 Mar 2012 14:38:17 -0800
Message-ID: <20120302223817.AC486A02DD@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qy0-f202.google.com ([209.85.216.202]:34089 "EHLO
	mail-qy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758137Ab2CBWiX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 2 Mar 2012 17:38:23 -0500
Received: by qcsp5 with SMTP id p5so272791qcs.1
        for <mm-commits@vger.kernel.org>; Fri, 02 Mar 2012 14:38:23 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: marcos.mage@gmail.com, len.brown@intel.com, lenb@kernel.org, srivatsa.bhat@linux.vnet.ibm.com


The patch titled
     Subject: drivers/idle/intel_idle.c: fix confusing code identation
has been added to the -mm tree.  Its filename is
     drivers-idle-intel_idlec-fix-confusing-code-identation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Marcos Paulo de Souza <marcos.mage@gmail.com>
Subject: drivers/idle/intel_idle.c: fix confusing code identation

Fix a code indentation in the function intel_idle_cpu_init that looks
confusing.o

Suggested-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Reviewed-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
Signed-off-by: Marcos Paulo de Souza <marcos.mage@gmail.com>
Cc: "Brown, Len" <len.brown@intel.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/idle/intel_idle.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff -puN drivers/idle/intel_idle.c~drivers-idle-intel_idlec-fix-confusing-code-identation drivers/idle/intel_idle.c
--- a/drivers/idle/intel_idle.c~drivers-idle-intel_idlec-fix-confusing-code-identation
+++ a/drivers/idle/intel_idle.c
@@ -507,8 +507,7 @@ int intel_idle_cpu_init(int cpu)
 		int num_substates;
 
 		if (cstate > max_cstate) {
-			printk(PREFIX "max_cstate %d reached\n",
-			       max_cstate);
+			printk(PREFIX "max_cstate %d reached\n", max_cstate);
 			break;
 		}
 
@@ -524,8 +523,9 @@ int intel_idle_cpu_init(int cpu)
 		dev->states_usage[dev->state_count].driver_data =
 			(void *)get_driver_data(cstate);
 
-			dev->state_count += 1;
-		}
+		dev->state_count += 1;
+	}
+
 	dev->cpu = cpu;
 
 	if (cpuidle_register_device(dev)) {
_
Subject: Subject: drivers/idle/intel_idle.c: fix confusing code identation

Patches currently in -mm which might be from marcos.mage@gmail.com are

linux-next.patch
drivers-idle-intel_idlec-fix-confusing-code-identation.patch


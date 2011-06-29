From: akpm@linux-foundation.org
Subject: + acpi-remove-nid_inval.patch added to -mm tree
Date: Wed, 29 Jun 2011 15:24:46 -0700
Message-ID: <201106292224.p5TMOkTL015868@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46089 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752657Ab1F2WYs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 29 Jun 2011 18:24:48 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rientjes@google.com, lenb@kernel.org


The patch titled
     acpi: remove NID_INVAL
has been added to the -mm tree.  Its filename is
     acpi-remove-nid_inval.patch

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
Subject: acpi: remove NID_INVAL
From: David Rientjes <rientjes@google.com>

b552a8c56db8 ("ACPI: remove NID_INVAL") removed the left over uses of
NID_INVAL, but didn't actually remove the definition.  Remove it.

Signed-off-by: David Rientjes <rientjes@google.com>
Cc: Len Brown <lenb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/acpi.h |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/acpi.h~acpi-remove-nid_inval include/linux/acpi.h
--- a/include/linux/acpi.h~acpi-remove-nid_inval
+++ a/include/linux/acpi.h
@@ -238,7 +238,6 @@ extern int acpi_paddr_to_node(u64 start_
 extern int pnpacpi_disabled;
 
 #define PXM_INVAL	(-1)
-#define NID_INVAL	(-1)
 
 int acpi_check_resource_conflict(const struct resource *res);
 
_

Patches currently in -mm which might be from rientjes@google.com are

linux-next.patch
acpi-remove-nid_inval.patch
mm-page_cgroupc-simplify-code-by-using-section_align_up-and-section_align_down-macros.patch
oom-remove-references-to-old-badness-function.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
proc-pid-fdinfo-add-cloexec-information.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch


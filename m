From: akpm@linux-foundation.org
Subject: [merged] thp-transparent_hugepage=-can-also-be-specified-on-cmdline.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:18:22 -0700
Message-ID: <20120322201822.6DDC8A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-qc0-f202.google.com ([209.85.216.202]:51317 "EHLO
	mail-qc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758859Ab2CVUSX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:18:23 -0400
Received: by qcsp5 with SMTP id p5so201658qcs.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:18:22 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jkosina@suse.cz, aarcange@redhat.com, mel@csn.ul.ie, mm-commits@vger.kernel.org


The patch titled
     Subject: thp: documentation: 'transparent_hugepage=' can also be specified on cmdline
has been removed from the -mm tree.  Its filename was
     thp-transparent_hugepage=-can-also-be-specified-on-cmdline.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jiri Kosina <jkosina@suse.cz>
Subject: thp: documentation: 'transparent_hugepage=' can also be specified on cmdline

The behavior of THP can either be toggled through sysfs in runtime or
using a kernel cmdline parameter 'transparent_hugepage='.  Document the
latter in kernel-parameters.txt

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mel Gorman <mel@csn.ul.ie>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kernel-parameters.txt |    7 +++++++
 1 file changed, 7 insertions(+)

diff -puN Documentation/kernel-parameters.txt~thp-transparent_hugepage=-can-also-be-specified-on-cmdline Documentation/kernel-parameters.txt
--- a/Documentation/kernel-parameters.txt~thp-transparent_hugepage=-can-also-be-specified-on-cmdline
+++ a/Documentation/kernel-parameters.txt
@@ -2635,6 +2635,13 @@ bytes respectively. Such letter suffixes
 			to facilitate early boot debugging.
 			See also Documentation/trace/events.txt
 
+	transparent_hugepage=
+			[KNL]
+			Format: [always|madvise|never]
+			Can be used to control the default behavior of the system
+			with respect to transparent hugepages.
+			See Documentation/vm/transhuge.txt for more details.
+
 	tsc=		Disable clocksource stability checks for TSC.
 			Format: <string>
 			[x86] reliable: mark tsc clocksource as reliable, this
_

Patches currently in -mm which might be from jkosina@suse.cz are

origin.patch
linux-next.patch


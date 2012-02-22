From: akpm@linux-foundation.org
Subject: + thp-transparent_hugepage=-can-also-be-specified-on-cmdline.patch added to -mm tree
Date: Wed, 22 Feb 2012 12:56:24 -0800
Message-ID: <20120222205624.A5215A00AB@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:49846 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754560Ab2BVU41 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 22 Feb 2012 15:56:27 -0500
Received: by bkcjk13 with SMTP id jk13so17379bkc.1
        for <mm-commits@vger.kernel.org>; Wed, 22 Feb 2012 12:56:25 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jkosina@suse.cz, aarcange@redhat.com, mel@csn.ul.ie


The patch titled
     Subject: thp: documentation: 'transparent_hugepage=' can also be specified on cmdline
has been added to the -mm tree.  Its filename is
     thp-transparent_hugepage=-can-also-be-specified-on-cmdline.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -2651,6 +2651,13 @@ bytes respectively. Such letter suffixes
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
Subject: Subject: thp: documentation: 'transparent_hugepage=' can also be specified on cmdline

Patches currently in -mm which might be from jkosina@suse.cz are

linux-next.patch
thp-transparent_hugepage=-can-also-be-specified-on-cmdline.patch


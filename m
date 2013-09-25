From: akpm@linux-foundation.org
Subject: +
 documentation-trace-tracepointstxt-add-links-to-trace_event-documentation.patch added to -mm tree
Date: Wed, 25 Sep 2013 15:19:49 -0700
Message-ID: <52436185.8amAYeedSyBfueW4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:50291 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754831Ab3IYWTu (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 25 Sep 2013 18:19:50 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, zoltan.kiss@citrix.com, rostedt@goodmis.org, rob@landley.net, mathieu.desnoyers@efficios.com, jkosina@suse.cz, raspl@linux.vnet.ibm.com

Subject: + documentation-trace-tracepointstxt-add-links-to-trace_event-documentation.patch added to -mm tree
To: raspl@linux.vnet.ibm.com,jkosina@suse.cz,mathieu.desnoyers@efficios.com,rob@landley.net,rostedt@goodmis.org,zoltan.kiss@citrix.com
From: akpm@linux-foundation.org
Date: Wed, 25 Sep 2013 15:19:49 -0700


The patch titled
     Subject: Documentation/trace/tracepoints.txt: add links to TRACE_EVENT documentation
has been added to the -mm tree.  Its filename is
     documentation-trace-tracepointstxt-add-links-to-trace_event-documentation.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-trace-tracepointstxt-add-links-to-trace_event-documentation.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-trace-tracepointstxt-add-links-to-trace_event-documentation.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stefan Raspl <raspl@linux.vnet.ibm.com>
Subject: Documentation/trace/tracepoints.txt: add links to TRACE_EVENT documentation

Existing tracepoint documentation doesn't mention the popular TRACE_EVENT
macro.  Since an excellent series of articles on proper usage already
exists, respective links are added to the existing documentation.

Signed-off-by: Stefan Raspl <raspl@linux.vnet.ibm.com>
Cc: Rob Landley <rob@landley.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/trace/tracepoints.txt |    5 +++++
 1 file changed, 5 insertions(+)

diff -puN Documentation/trace/tracepoints.txt~documentation-trace-tracepointstxt-add-links-to-trace_event-documentation Documentation/trace/tracepoints.txt
--- a/Documentation/trace/tracepoints.txt~documentation-trace-tracepointstxt-add-links-to-trace_event-documentation
+++ a/Documentation/trace/tracepoints.txt
@@ -114,3 +114,8 @@ core kernel image or in modules.
 If the tracepoint has to be used in kernel modules, an
 EXPORT_TRACEPOINT_SYMBOL_GPL() or EXPORT_TRACEPOINT_SYMBOL() can be
 used to export the defined tracepoints.
+
+Note: The convenience macro TRACE_EVENT provides an alternative way to
+      define tracepoints. Check http://lwn.net/Articles/379903,
+      http://lwn.net/Articles/381064 and http://lwn.net/Articles/383362
+      for a series of articles with more details.
_

Patches currently in -mm which might be from raspl@linux.vnet.ibm.com are

documentation-trace-tracepointstxt-add-links-to-trace_event-documentation.patch


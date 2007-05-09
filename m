From: akpm@linux-foundation.org
Subject: - add-info-about-whitespace-to-submitchecklist.patch removed from -mm tree
Date: Wed, 09 May 2007 14:50:07 -0700
Message-ID: <200705092150.l49Lo7RQ002773@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:45542 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754720AbXEIVuM (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 17:50:12 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rdreier@cisco.com, rolandd@cisco.com, mm-commits@vger.kernel.org


The patch titled
     Add info about whitespace to SubmitChecklist
has been removed from the -mm tree.  Its filename was
     add-info-about-whitespace-to-submitchecklist.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Add info about whitespace to SubmitChecklist
From: Roland Dreier <rdreier@cisco.com>

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    4 ++++
 1 file changed, 4 insertions(+)

diff -puN Documentation/SubmitChecklist~add-info-about-whitespace-to-submitchecklist Documentation/SubmitChecklist
--- a/Documentation/SubmitChecklist~add-info-about-whitespace-to-submitchecklist
+++ a/Documentation/SubmitChecklist
@@ -80,3 +80,7 @@ kernel patches.
 23: Tested after it has been merged into the -mm patchset to make sure
     that it still works with all of the other queued patches and various
     changes in the VM, VFS, and other subsystems.
+
+24: Avoid whitespace damage such as indenting with spaces or whitespace
+    at the end of lines.  You can test this by feeding the patch to
+    "git apply --check --whitespace=error-all"
_

Patches currently in -mm which might be from rdreier@cisco.com are

origin.patch

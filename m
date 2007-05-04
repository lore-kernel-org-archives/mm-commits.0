From: akpm@linux-foundation.org
Subject: + add-info-about-whitespace-to-submitchecklist.patch added to -mm tree
Date: Thu, 03 May 2007 18:08:41 -0700
Message-ID: <200705040108.l4418fci026377@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:58164 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754447AbXEDBIq (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 May 2007 21:08:46 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rdreier@cisco.com, rolandd@cisco.com


The patch titled
     Add info about whitespace to SubmitChecklist
has been added to the -mm tree.  Its filename is
     add-info-about-whitespace-to-submitchecklist.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Add info about whitespace to SubmitChecklist
From: Roland Dreier <rdreier@cisco.com>

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmitChecklist |    4 ++++
 1 files changed, 4 insertions(+)

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

add-info-about-whitespace-to-submitchecklist.patch

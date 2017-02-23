From: akpm@linux-foundation.org
Subject: [merged] scripts-spellingtxt-fix-incorrect-typo-words.patch
 removed from -mm tree
Date: Thu, 23 Feb 2017 13:11:37 -0800
Message-ID: <58af5009.dpP9o+dOezEgvYxJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38314 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751272AbdBWVLi (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 23 Feb 2017 16:11:38 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: fix incorrect typo-words
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-fix-incorrect-typo-words.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: scripts/spelling.txt: fix incorrect typo-words

Fix up some incorrect typo-words.

[akpm@linux-foundation.org: "licencing" is valid British spelling and should be kept, per Joe]
Link: http://lkml.kernel.org/r/1486409689-23335-1-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff -puN scripts/spelling.txt~scripts-spellingtxt-fix-incorrect-typo-words scripts/spelling.txt
--- a/scripts/spelling.txt~scripts-spellingtxt-fix-incorrect-typo-words
+++ a/scripts/spelling.txt
@@ -40,7 +40,7 @@ achitecture||architecture
 acient||ancient
 acitions||actions
 acitve||active
-acknowldegement||acknowldegement
+acknowldegement||acknowledgment
 acknowledgement||acknowledgment
 ackowledge||acknowledge
 ackowledged||acknowledged
@@ -573,7 +573,7 @@ intrrupt||interrupt
 intterrupt||interrupt
 intuative||intuitive
 invaid||invalid
-invalde||invald
+invalde||invalid
 invalide||invalid
 invididual||individual
 invokation||invocation
@@ -1020,7 +1020,7 @@ tramsmitted||transmitted
 tramsmit||transmit
 tranfer||transfer
 transciever||transceiver
-transferd||transferrd
+transferd||transferred
 transfered||transferred
 transfering||transferring
 transision||transition
_

Patches currently in -mm which might be from ross.zwisler@linux.intel.com are

mmfsdax-change-pmd_fault-to-huge_fault-fix-2.patch
drm-remove-unnecessary-fault-wrappers.patch


From: akpm@linux-foundation.org
Subject: + scripts-spellingtxt-fix-incorrect-typo-words.patch added to -mm tree
Date: Mon, 06 Feb 2017 15:07:11 -0800
Message-ID: <5899019f.aOu98b/5jdlj6leQ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:34416 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751920AbdBFXHM (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 6 Feb 2017 18:07:12 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ross.zwisler@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: fix incorrect typo-words
has been added to the -mm tree.  Its filename is
     scripts-spellingtxt-fix-incorrect-typo-words.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/scripts-spellingtxt-fix-incorrect-typo-words.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/scripts-spellingtxt-fix-incorrect-typo-words.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Ross Zwisler <ross.zwisler@linux.intel.com>
Subject: scripts/spelling.txt: fix incorrect typo-words

Fix up some incorrect typo-words.

Link: http://lkml.kernel.org/r/1486409689-23335-1-git-send-email-ross.zwisler@linux.intel.com
Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

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
@@ -604,7 +604,7 @@ libaries||libraries
 libary||library
 librairies||libraries
 libraris||libraries
-licenceing||licencing
+licenceing||licensing
 loggging||logging
 loggin||login
 logile||logfile
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

tracing-add-__print_flags_u64.patch
dax-add-tracepoint-infrastructure-pmd-tracing.patch
dax-update-maintainers-entries-for-fs-dax.patch
dax-add-tracepoints-to-dax_pmd_load_hole.patch
dax-add-tracepoints-to-dax_pmd_insert_mapping.patch
scripts-spellingtxt-fix-incorrect-typo-words.patch
mmfsdax-change-pmd_fault-to-huge_fault-fix-2.patch
drm-remove-unnecessary-fault-wrappers.patch


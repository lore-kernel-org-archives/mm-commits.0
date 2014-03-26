From: akpm@linux-foundation.org
Subject: + documentation-submittingpatches-update-some-dead-urls.patch
 added to -mm tree
Date: Wed, 26 Mar 2014 14:56:15 -0700
Message-ID: <53334cff.g5lQxc3N4vCRycDI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58269 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaCZV4Q (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 17:56:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mitchelh@codeaurora.org

Subject: + documentation-submittingpatches-update-some-dead-urls.patch added to -mm tree
To: mitchelh@codeaurora.org
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 14:56:15 -0700


The patch titled
     Subject: Documentation/SubmittingPatches: update some dead URLs
has been added to the -mm tree.  Its filename is
     documentation-submittingpatches-update-some-dead-urls.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-submittingpatches-update-some-dead-urls.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-submittingpatches-update-some-dead-urls.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Mitchel Humpherys <mitchelh@codeaurora.org>
Subject: Documentation/SubmittingPatches: update some dead URLs

The links to "The perfect patch" and "NO!!!! No more huge patch
bombs..." have gone stale. Update them to some working locations.

Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/SubmittingPatches       |    4 ++--
 Documentation/ja_JP/SubmittingPatches |    4 ++--
 Documentation/zh_CN/SubmittingPatches |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)

diff -puN Documentation/SubmittingPatches~documentation-submittingpatches-update-some-dead-urls Documentation/SubmittingPatches
--- a/Documentation/SubmittingPatches~documentation-submittingpatches-update-some-dead-urls
+++ a/Documentation/SubmittingPatches
@@ -739,7 +739,7 @@ SECTION 3 - REFERENCES
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
+  <http://www.ozlabs.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
@@ -752,7 +752,7 @@ Greg Kroah-Hartman, "How to piss off a k
   <http://www.kroah.com/log/linux/maintainer-05.html>
 
 NO!!!! No more huge patch bombs to linux-kernel@vger.kernel.org people!
-  <http://marc.theaimsgroup.com/?l=linux-kernel&m=112112749912944&w=2>
+  <https://lkml.org/lkml/2005/7/11/336>
 
 Kernel Documentation/CodingStyle:
   <http://users.sosdg.org/~qiyong/lxr/source/Documentation/CodingStyle>
diff -puN Documentation/ja_JP/SubmittingPatches~documentation-submittingpatches-update-some-dead-urls Documentation/ja_JP/SubmittingPatches
--- a/Documentation/ja_JP/SubmittingPatches~documentation-submittingpatches-update-some-dead-urls
+++ a/Documentation/ja_JP/SubmittingPatches
@@ -695,7 +695,7 @@ gcc においては、マクロと同じ
 ----------------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
+  <http://www.ozlabs.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
@@ -707,7 +707,7 @@ Greg Kroah-Hartman, "How to piss off a k
   <http://www.kroah.com/log/2006/01/11/>
 
 NO!!!! No more huge patch bombs to linux-kernel@vger.kernel.org people!
-  <http://marc.theaimsgroup.com/?l=linux-kernel&m=112112749912944&w=2>
+  <https://lkml.org/lkml/2005/7/11/336>
 
 Kernel Documentation/CodingStyle:
   <http://users.sosdg.org/~qiyong/lxr/source/Documentation/CodingStyle>
diff -puN Documentation/zh_CN/SubmittingPatches~documentation-submittingpatches-update-some-dead-urls Documentation/zh_CN/SubmittingPatches
--- a/Documentation/zh_CN/SubmittingPatches~documentation-submittingpatches-update-some-dead-urls
+++ a/Documentation/zh_CN/SubmittingPatches
@@ -394,7 +394,7 @@ Static inline 函数相比宏来说，�
 ----------------
 
 Andrew Morton, "The perfect patch" (tpp).
-  <http://userweb.kernel.org/~akpm/stuff/tpp.txt>
+  <http://www.ozlabs.org/~akpm/stuff/tpp.txt>
 
 Jeff Garzik, "Linux kernel patch submission format".
   <http://linux.yyz.us/patch-format.html>
@@ -406,7 +406,7 @@ Greg Kroah-Hartman, "How to piss off a k
   <http://www.kroah.com/log/2006/01/11/>
 
 NO!!!! No more huge patch bombs to linux-kernel@vger.kernel.org people!
-  <http://marc.theaimsgroup.com/?l=linux-kernel&m=112112749912944&w=2>
+  <https://lkml.org/lkml/2005/7/11/336>
 
 Kernel Documentation/CodingStyle:
   <http://sosdg.org/~coywolf/lxr/source/Documentation/CodingStyle>
_

Patches currently in -mm which might be from mitchelh@codeaurora.org are

documentation-submittingpatches-update-some-dead-urls.patch
documentation-submittingpatches-remove-references-to-patch-scripts.patch
linux-next.patch


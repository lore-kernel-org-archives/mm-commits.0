From: akpm@linux-foundation.org
Subject: +
 documentation-submittingpatches-remove-references-to-patch-scripts.patch
 added to -mm tree
Date: Wed, 26 Mar 2014 14:56:16 -0700
Message-ID: <53334d00.bVdJStDe7yU5nD+n%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: application/octet-stream
Content-Transfer-Encoding: 8bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58271 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaCZV4R (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 26 Mar 2014 17:56:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mitchelh@codeaurora.org

Subject: + documentation-submittingpatches-remove-references-to-patch-scripts.patch added to -mm tree
To: mitchelh@codeaurora.org
From: akpm@linux-foundation.org
Date: Wed, 26 Mar 2014 14:56:16 -0700


The patch titled
     Subject: Documentation/SubmittingPatches: remove references to patch-scripts
has been added to the -mm tree.  Its filename is
     documentation-submittingpatches-remove-references-to-patch-scripts.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/documentation-submittingpatches-remove-references-to-patch-scripts.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/documentation-submittingpatches-remove-references-to-patch-scripts.patch

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
Subject: Documentation/SubmittingPatches: remove references to patch-scripts

The link to the tarball for Andrew Morton's patch scripts is dead. These
scripts don't seem to be used for kernel development these days anyways
so just rip out all references to them.

Signed-off-by: Mitchel Humpherys <mitchelh@codeaurora.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/ja_JP/SubmittingPatches |    5 -----
 Documentation/zh_CN/SubmittingPatches |    4 ----
 2 files changed, 9 deletions(-)

diff -puN Documentation/ja_JP/SubmittingPatches~documentation-submittingpatches-remove-references-to-patch-scripts Documentation/ja_JP/SubmittingPatches
--- a/Documentation/ja_JP/SubmittingPatches~documentation-submittingpatches-remove-references-to-patch-scripts
+++ a/Documentation/ja_JP/SubmittingPatches
@@ -98,11 +98,6 @@ dontdiff ファイルには Linux カー
 Quilt:
 http://savannah.nongnu.org/projects/quilt
 
-Andrew Morton's patch scripts:
-http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
-このリンクの先のスクリプトの代わりとして、quilt がパッチマネジメント
-ツールとして推奨されています(上のリンクを見てください)。
-
 2) パッチに対する説明
 
 パッチの中の変更点に対する技術的な詳細について説明してください。
diff -puN Documentation/zh_CN/SubmittingPatches~documentation-submittingpatches-remove-references-to-patch-scripts Documentation/zh_CN/SubmittingPatches
--- a/Documentation/zh_CN/SubmittingPatches~documentation-submittingpatches-remove-references-to-patch-scripts
+++ a/Documentation/zh_CN/SubmittingPatches
@@ -82,10 +82,6 @@ Documentation/SubmittingDrivers 。
 Quilt:
 http://savannah.nongnu.org/projects/quilt
 
-Andrew Morton 的补丁脚本:
-http://userweb.kernel.org/~akpm/stuff/patch-scripts.tar.gz
-作为这些脚本的替代，quilt 是值得推荐的补丁管理工具(看上面的链接)。

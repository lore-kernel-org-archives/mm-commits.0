Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 658BAC433F5
	for <mm-commits@archiver.kernel.org>; Thu, 16 Dec 2021 22:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhLPWcP (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 16 Dec 2021 17:32:15 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:49108 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230462AbhLPWcO (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 16 Dec 2021 17:32:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EE6261F7C
        for <mm-commits@vger.kernel.org>; Thu, 16 Dec 2021 22:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B18A6C36AE7;
        Thu, 16 Dec 2021 22:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1639693933;
        bh=WESq6K6i0ZN1Im/lJ8AkzazANZfWy/9gj3PcPpvbOqk=;
        h=Date:From:To:Subject:From;
        b=aPvIDfyMWGCKF0Dpzco0Tx84o+0XuZXxU+INeLyn+4JPTGl3SevZsQHMrstH1pSIP
         /W2+Gq2XYXgtJFUSbtnSB1uSWs/4IIqbPHEa/liPrkFIF7cBwf72G+1dlYaderXxpM
         NekXP5pY1vze2gRGkiTFKmj9TBYB1Ui2DVlFEFNM=
Date:   Thu, 16 Dec 2021 14:32:13 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, corbet@lwn.net,
        skhan@linuxfoundation.org
Subject:  +
 docs-vm-fix-unexpected-indentation-warns-in-page_owner.patch added to -mm
 tree
Message-ID: <20211216223213.afd2R%akpm@linux-foundation.org>
User-Agent: s-nail v14.9.10
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/vm/page_owner.rst: fix unexpected indentation warns
has been added to the -mm tree.  Its filename is
     docs-vm-fix-unexpected-indentation-warns-in-page_owner.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/docs-vm-fix-unexpected-indentation-warns-in-page_owner.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/docs-vm-fix-unexpected-indentation-warns-in-page_owner.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Shuah Khan <skhan@linuxfoundation.org>
Subject: Documentation/vm/page_owner.rst: fix unexpected indentation warns

Fix Unexpected indentation warns in page_owner:

Documentation/vm/page_owner.rst:92: WARNING: Unexpected indentation.
Documentation/vm/page_owner.rst:96: WARNING: Unexpected indentation.
Documentation/vm/page_owner.rst:107: WARNING: Unexpected indentation.

Link: https://lkml.kernel.org/r/20211215001929.47866-1-skhan@linuxfoundation.org
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/vm/page_owner.rst |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/Documentation/vm/page_owner.rst~docs-vm-fix-unexpected-indentation-warns-in-page_owner
+++ a/Documentation/vm/page_owner.rst
@@ -89,11 +89,11 @@ Usage
 
 	Page allocated via order XXX, ...
 	PFN XXX ...
-	 // Detailed stack
+	// Detailed stack
 
 	Page allocated via order XXX, ...
 	PFN XXX ...
-	 // Detailed stack
+	// Detailed stack
 
    The ``page_owner_sort`` tool ignores ``PFN`` rows, puts the remaining rows
    in buf, uses regexp to extract the page order value, counts the times
@@ -104,7 +104,7 @@ Usage
 
 	XXX times, XXX pages:
 	Page allocated via order XXX, ...
-	 // Detailed stack
+	// Detailed stack
 
    By default, ``page_owner_sort`` is sorted according to the times of buf.
    If you want to sort by the page nums of buf, use the ``-m`` parameter.
_

Patches currently in -mm which might be from skhan@linuxfoundation.org are

docs-vm-fix-unexpected-indentation-warns-in-page_owner.patch


Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A833C433ED
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3DFB16143B
	for <mm-commits@archiver.kernel.org>; Sat,  8 May 2021 22:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbhEHWz4 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sat, 8 May 2021 18:55:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229660AbhEHWz4 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Sat, 8 May 2021 18:55:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73EED6142D;
        Sat,  8 May 2021 22:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1620514494;
        bh=WFprAnvW0hfljcRHWlBFIE4Wg3w0F7vais+VPY2pZnY=;
        h=Date:From:To:Subject:From;
        b=O/LCfX5aW+wROgb6hlVBwECIA/JVHEF3j52KUOPfoa1reNToZKlfVRcojzrIxVdFY
         jl2HTwIpcOeUMJMzkhf57/Iz0ChmPox2+ryYwEo9L5EWJSJMd2o9jUUUcd0BeSL1Nl
         fpR/XddxNku226VmkwRiBZwGLLvmgaMJbmq0reqA=
Date:   Sat, 08 May 2021 15:54:54 -0700
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zuoqilin@yulong.com
Subject:  [merged] scripts-spellingtxt-add-diabled-typo.patch
 removed from -mm tree
Message-ID: <20210508225454.U1k7eGpm9%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: add "diabled" typo
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-add-diabled-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zuoqilin <zuoqilin@yulong.com>
Subject: scripts/spelling.txt: Add "diabled" typo

Increase "diabled" spelling error check.

Link: https://lkml.kernel.org/r/20210304070106.2313-1-zuoqilin1@163.com
Signed-off-by: zuoqilin <zuoqilin@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-diabled-typo
+++ a/scripts/spelling.txt
@@ -480,6 +480,7 @@ devided||divided
 deviece||device
 devision||division
 diable||disable
+diabled||disabled
 dicline||decline
 dictionnary||dictionary
 didnt||didn't
_

Patches currently in -mm which might be from zuoqilin@yulong.com are



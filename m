Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE38BC433DB
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 76A3164F72
	for <mm-commits@archiver.kernel.org>; Thu, 25 Feb 2021 19:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233025AbhBYTOc (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Feb 2021 14:14:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:54798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234114AbhBYTL7 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 25 Feb 2021 14:11:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9E42F64F27;
        Thu, 25 Feb 2021 19:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1614280277;
        bh=NuQOXGm+QrIHBwrNIs2uH/0csUWn5d/j6QTJfKtqS/Y=;
        h=Date:From:To:Subject:From;
        b=uBT7+T+IvKcVVwLw9AgatHGO+n/LbP1Usu6ic3RjaMQxSvPqLRNFWWaRAWU5bol0a
         VeVaw54Pgis+MdKddPkYWDIHkQgCfvpJ6+dkMGK+7FeMi8Lr5r8GlzDofuXCvpOCpx
         8PmJ4QooO8Z4SXsSD7WGzsEDmCc6+RA7nRgFCLuQ=
Date:   Thu, 25 Feb 2021 11:11:17 -0800
From:   akpm@linux-foundation.org
To:     mm-commits@vger.kernel.org, zuoqilin@yulong.com
Subject:  [merged]
 scripts-spellingtxt-increase-error-prone-spell-checking-2.patch removed
 from -mm tree
Message-ID: <20210225191117.1InEV0LlP%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org


The patch titled
     Subject: scripts/spelling.txt: check for "exeeds"
has been removed from the -mm tree.  Its filename was
     scripts-spellingtxt-increase-error-prone-spell-checking-2.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: zuoqilin <zuoqilin@yulong.com>
Subject: scripts/spelling.txt: check for "exeeds"

Increase exeeds spelling error check.

Link: https://lkml.kernel.org/r/20210127060049.915-1-zuoqilin1@163.com
Signed-off-by: zuoqilin <zuoqilin@yulong.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-increase-error-prone-spell-checking-2
+++ a/scripts/spelling.txt
@@ -566,6 +566,7 @@ estbalishment||establishment
 etsablishment||establishment
 etsbalishment||establishment
 evalution||evaluation
+exeeds||exceeds
 excecutable||executable
 exceded||exceeded
 exceds||exceeds
_

Patches currently in -mm which might be from zuoqilin@yulong.com are



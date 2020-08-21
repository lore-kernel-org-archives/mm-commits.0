Return-Path: <SRS0=KdEm=B7=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CECD7C433E1
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:41:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A1EA0207BB
	for <mm-commits@archiver.kernel.org>; Fri, 21 Aug 2020 00:41:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597970517;
	bh=FwlvRRKRYV/FKUpkc/Zn/Mq5pqAN3xBk0fh+YHB0A/I=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=151xIhfpdcC8NMWiHUaT2xiKRt7J8dI99RI3irFzoZS58ta+MkJ5U95ghaE44D92x
	 SYmLS0LiVl73m39TFS/FdSNAC5BKTJu05w7T5UZNStWB7WtEMrVSFAPcg44klSP3Fc
	 C6IkraeT9Zkg98RwfZiabNzQt87Q5CXgabRqazzY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgHUAl5 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 20 Aug 2020 20:41:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbgHUAl5 (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 20 Aug 2020 20:41:57 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E6C120738;
        Fri, 21 Aug 2020 00:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597970516;
        bh=FwlvRRKRYV/FKUpkc/Zn/Mq5pqAN3xBk0fh+YHB0A/I=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ms/aUCCpJxFfmU/w3Qa6KfjYwerMQ5FkVjtYzbU1LtORZpC3vR2f3nXd3w3pZZRs4
         tgPpYXlwMjO2chznMMsvOCRjfPJ38WGmYAZACC5i+E8JIpQQmoF92lqJ4MoSEAZvd0
         f56JdAG2HPFn6xo2BiYT069RfiuZ8bMftNXTPdkg=
Date:   Thu, 20 Aug 2020 17:41:56 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     ak@linux.intel.com, akpm@linux-foundation.org, corbet@lwn.net,
        keescook@chromium.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, ndesaulniers@google.com,
        qperret@qperret.net, torvalds@linux-foundation.org
Subject:  [patch 01/11] mailmap: add Andi Kleen
Message-ID: <20200821004156.F4ATcnFDz%akpm@linux-foundation.org>
In-Reply-To: <20200820174132.67fd4a7a9359048f807a533b@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: mm-commits-owner@vger.kernel.org
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Nick Desaulniers <ndesaulniers@google.com>
Subject: mailmap: add Andi Kleen

I keep getting bounce back from the suse.de address.

Link: http://lkml.kernel.org/r/20200818203214.659955-1-ndesaulniers@google.com
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Kees Cook <keescook@chromium.org>
Cc: Quentin Perret <qperret@qperret.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-add-andi-kleen
+++ a/.mailmap
@@ -32,6 +32,7 @@ Alex Shi <alex.shi@linux.alibaba.com> <a
 Alex Shi <alex.shi@linux.alibaba.com> <alex.shi@linaro.org>
 Al Viro <viro@ftp.linux.org.uk>
 Al Viro <viro@zenIV.linux.org.uk>
+Andi Kleen <ak@linux.intel.com> <ak@suse.de>
 Andi Shyti <andi@etezian.org> <andi.shyti@samsung.com>
 Andreas Herrmann <aherrman@de.ibm.com>
 Andrew Morton <akpm@linux-foundation.org>
_

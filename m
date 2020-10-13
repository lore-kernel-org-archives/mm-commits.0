Return-Path: <SRS0=1pWp=DU=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6E8C433DF
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7E80021D7A
	for <mm-commits@archiver.kernel.org>; Tue, 13 Oct 2020 23:48:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602632890;
	bh=ALic1zvYWCuJ6Yhyui544msxUHlwgwvcQwDrY37a+00=;
	h=Date:From:To:Subject:In-Reply-To:Reply-To:List-ID:From;
	b=fjAjd2+jUuo8GgbaCg5DntSQQAmKfZ8KblPqgJZv3XwOqb9sLbYqQPZZ9IDeZZfJY
	 yLJFcO9QYaYUihjhb2DPeB3+HsICtnCNOWRBhAtBCiJiwCufB9LqCb+AlOD1KqB//D
	 YvrDBn+J6Q+aGOy0R8Lb5aejh/xpxDnm71TNxGS4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389136AbgJMXsK (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 13 Oct 2020 19:48:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:59418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389017AbgJMXsK (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 13 Oct 2020 19:48:10 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0F0821D7B;
        Tue, 13 Oct 2020 23:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602632889;
        bh=ALic1zvYWCuJ6Yhyui544msxUHlwgwvcQwDrY37a+00=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=e8dFuKFeVGPp1wDx24xnn/5OQvQPNTIADsepsDqYln79PZlq17+YaMEXcLBHRbm1x
         HEvL9G6xIV2nF9nklif/4BNkClBOWSRpLnoE7RnQynJB0bk4LBErcuXKZBR8N7gN8Y
         NRR7iKKuBad6Y/alt4OE1x4W5YNIl+ng0ycx2Scw=
Date:   Tue, 13 Oct 2020 16:48:08 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@canonical.com,
        j.neuschaefer@gmx.net, joe@perches.com, linux-mm@kvack.org,
        luca@lucaceresoli.net, mm-commits@vger.kernel.org,
        sjpark@amazon.de, torvalds@linux-foundation.org, wangqing@vivo.com,
        xndchn@gmail.com
Subject:  [patch 011/181] scripts/spelling.txt: increase
 error-prone spell checking
Message-ID: <20201013234808.6Dy9VJGJO%akpm@linux-foundation.org>
In-Reply-To: <20201013164658.3bfd96cc224d8923e66a9f4e@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>
Subject: scripts/spelling.txt: increase error-prone spell checking

Increase direcly,ununsed,manger spelling error check

Link: https://lkml.kernel.org/r/1601085397-27586-1-git-send-email-wangqing@vivo.com
Signed-off-by: Wang Qing <wangqing@vivo.com>
Cc: Colin Ian King <colin.king@canonical.com>
Cc: Wang Qing <wangqing@vivo.com>
Cc: Xiong <xndchn@gmail.com>
Cc: SeongJae Park <sjpark@amazon.de>
Cc: Jonathan Neuschfer <j.neuschaefer@gmx.net>
Cc: Luca Ceresoli <luca@lucaceresoli.net>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    3 +++
 1 file changed, 3 insertions(+)

--- a/scripts/spelling.txt~increase-error-prone-spell-checking
+++ a/scripts/spelling.txt
@@ -482,6 +482,7 @@ disgest||digest
 dispalying||displaying
 diplay||display
 directon||direction
+direcly||directly
 direectly||directly
 diregard||disregard
 disassocation||disassociation
@@ -871,6 +872,7 @@ malplace||misplace
 managable||manageable
 managment||management
 mangement||management
+manger||manager
 manoeuvering||maneuvering
 manufaucturing||manufacturing
 mappping||mapping
@@ -1478,6 +1480,7 @@ unsolicitied||unsolicited
 unsuccessfull||unsuccessful
 unsuported||unsupported
 untill||until
+ununsed||unused
 unuseful||useless
 unvalid||invalid
 upate||update
_

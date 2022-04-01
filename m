Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 316C7C433F5
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:28:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347575AbiDASap (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351040AbiDASaa (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:30:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C341BA683
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:28:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D814A60F19
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CE2C2BBE4;
        Fri,  1 Apr 2022 18:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837720;
        bh=aT12qv/wZknok1Ce5MUhi+IHWGN6xFOfC6tQPEvg3u0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=mjjCatmZ7bcOZXOCBtgvF7icUOwNyuf1DaDxjVpiJIrUs6ut5KF038s3AaScXX3nw
         TdXQdkqfvafqRhu9Jhyh6+qFaowXennc9qJRkVSxJLzddUPNyo5tv9iA15uZTVaRmC
         ErlaLWhHTx6t4zjZYvIV3nMDg2w8BICu/rV+gUdc=
Date:   Fri, 01 Apr 2022 11:28:39 -0700
To:     kirill.tkhai@openvz.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220401112740.351496714b370467a92207a6@linux-foundation.org>
Subject: [patch 10/16] mailmap: update Kirill's email
Message-Id: <20220401182840.36CE2C2BBE4@smtp.kernel.org>
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Kirill Tkhai <kirill.tkhai@openvz.org>
Subject: mailmap: update Kirill's email

My new email address is kirill.tkhai@openvz.org.

Link: https://lkml.kernel.org/r/164846762354.278960.13129571556274098855.stgit@pro
Signed-off-by: Kirill Tkhai <kirill.tkhai@openvz.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 .mailmap |    1 +
 1 file changed, 1 insertion(+)

--- a/.mailmap~mailmap-update-kirills-email
+++ a/.mailmap
@@ -213,6 +213,7 @@ Kees Cook <keescook@chromium.org> <kees@
 Keith Busch <kbusch@kernel.org> <keith.busch@intel.com>
 Keith Busch <kbusch@kernel.org> <keith.busch@linux.intel.com>
 Kenneth W Chen <kenneth.w.chen@intel.com>
+Kirill Tkhai <kirill.tkhai@openvz.org> <ktkhai@virtuozzo.com>
 Konstantin Khlebnikov <koct9i@gmail.com> <khlebnikov@yandex-team.ru>
 Konstantin Khlebnikov <koct9i@gmail.com> <k.khlebnikov@samsung.com>
 Koushik <raghavendra.koushik@neterion.com>
_

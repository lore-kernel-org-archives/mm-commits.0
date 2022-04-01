Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4113EC433EF
	for <mm-commits@archiver.kernel.org>; Fri,  1 Apr 2022 18:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241331AbiDASXW (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 1 Apr 2022 14:23:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349795AbiDASXJ (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 1 Apr 2022 14:23:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D5B38198
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 11:21:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91AB260E8E
        for <mm-commits@vger.kernel.org>; Fri,  1 Apr 2022 18:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E765FC340F3;
        Fri,  1 Apr 2022 18:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1648837279;
        bh=aT12qv/wZknok1Ce5MUhi+IHWGN6xFOfC6tQPEvg3u0=;
        h=Date:To:From:In-Reply-To:Subject:From;
        b=qzEl+/CF2s4PvpJA8Uzm7kjqpvEPSo5CXzbn/P5g98zYu8C5j8S5LwEbsYKtF67E/
         BoqtC8YnAdf5b+j2a9gALULYhA11aWomiTuI+aXzG5Sm501HwPtcJpydeZkKQA0yPM
         KkympWtD4q58JkIGMJfPqcO9kA5yaj+eAGwUgTbg=
Date:   Fri, 01 Apr 2022 11:21:18 -0700
To:     kirill.tkhai@openvz.org, akpm@linux-foundation.org,
        patches@lists.linux.dev, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <l>
Subject: [patch 10/16] mailmap: update Kirill's email
Message-Id: <20220401182118.E765FC340F3@smtp.kernel.org>
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

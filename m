Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF974C433F5
	for <mm-commits@archiver.kernel.org>; Fri, 14 Jan 2022 22:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbiANWD3 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Fri, 14 Jan 2022 17:03:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiANWD3 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jan 2022 17:03:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D13EFC061574
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 14:03:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 91058B8262F
        for <mm-commits@vger.kernel.org>; Fri, 14 Jan 2022 22:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0DDC36AE9;
        Fri, 14 Jan 2022 22:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1642197806;
        bh=u3wrRiPF3Z6D6kDRf06hq6ekLBjCD2dUUJrMyl0La7Q=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=qiPK2ZbgtLpZ6QvFikz2kyT+MrdZj65x+tXeXxmVJeimtsKucYbiw7hh9Msgd7muk
         Gm9TiwSTj/C1O55FUeDDh7CYFMVuEQ/EsqXvihQhsFOuxuoKme3JPMJh5g60TBNd9x
         UWFFwIdU+ZgP9rQiYddwVIUH6yxJptUuPIMX8BHE=
Date:   Fri, 14 Jan 2022 14:03:25 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, colin.king@intel.com,
        dfustini@baylibre.com, gustavoars@kernel.org, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, sven@narfation.org,
        tom.saeger@oracle.com, torvalds@linux-foundation.org,
        zuoqilin@yulong.com
Subject:  [patch 011/146] scripts/spelling.txt: add "oveflow"
Message-ID: <20220114220325.gt0PHk9Tz%akpm@linux-foundation.org>
In-Reply-To: <20220114140222.6b14f0061194d3200000c52d@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

From: Drew Fustini <dfustini@baylibre.com>
Subject: scripts/spelling.txt: add "oveflow"

Add typo "oveflow" for "overflow".  This typo was found and fixed in
tools/testing/selftests/bpf/prog_tests/btf_dump.c

Link: https://lore.kernel.org/all/20211122070528.837806-1-dfustini@baylibre.com/
Link: https://lkml.kernel.org/r/20211122072302.839102-1-dfustini@baylibre.com
Signed-off-by: Drew Fustini <dfustini@baylibre.com>
Suggested-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Colin Ian King <colin.king@intel.com>
Cc: Drew Fustini <dfustini@baylibre.com>
Cc: zuoqilin <zuoqilin@yulong.com>
Cc: Tom Saeger <tom.saeger@oracle.com>
Cc: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/spelling.txt |    1 +
 1 file changed, 1 insertion(+)

--- a/scripts/spelling.txt~scripts-spellingtxt-add-oveflow
+++ a/scripts/spelling.txt
@@ -1046,6 +1046,7 @@ oustanding||outstanding
 overaall||overall
 overhread||overhead
 overlaping||overlapping
+oveflow||overflow
 overflw||overflow
 overlfow||overflow
 overide||override
_

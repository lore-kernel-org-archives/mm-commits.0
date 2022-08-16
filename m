Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D94D8C25B0E
	for <mm-commits@archiver.kernel.org>; Tue, 16 Aug 2022 23:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230264AbiHPXll (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 16 Aug 2022 19:41:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiHPXlk (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 16 Aug 2022 19:41:40 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC8837B7BD
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 16:41:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6583861337
        for <mm-commits@vger.kernel.org>; Tue, 16 Aug 2022 23:41:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C1AC433D6;
        Tue, 16 Aug 2022 23:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1660693298;
        bh=AD1GUiOtHWxAmte7r+VkUNnNVlakN0Obx/M0rMOYAfw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k1txib1bUvkZ1Z6MgAcJKTLKUYw4WGpVvJHzEAnkuse8p7jedXtQqLnRtc0Zj6chU
         +tPqKoxpa6O4PXZ4cnWPbULM05Rvysaosp0Sz0tIZBJkEYLoeg4jS3w+GsL5boroaW
         9P0Ai+ev5vLIw4I4Zb97DM4tsW43ou9PbhlL/XVw=
Date:   Tue, 16 Aug 2022 16:41:37 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Charan Teja Kalla <quic_charante@quicinc.com>
Cc:     <mm-commits@vger.kernel.org>, <willy@infradead.org>,
        <sjpark@amazon.de>, <sieberf@amazon.com>, <shakeelb@google.com>,
        <quic_pkondeti@quicinc.com>, <pasha.tatashin@soleen.com>,
        <mhocko@suse.com>, <dhowells@redhat.com>, <david@redhat.com>
Subject: Re: +
 mm-fix-use-after-free-of-page_ext-after-race-with-memory-offline.patch
 added to mm-unstable branch
Message-Id: <20220816164137.6208e8dca75100b4f1b95832@linux-foundation.org>
In-Reply-To: <d2e7af00-6d76-7c6d-b742-b2e59c572966@quicinc.com>
References: <20220810015718.F0936C433C1@smtp.kernel.org>
        <d2e7af00-6d76-7c6d-b742-b2e59c572966@quicinc.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

On Tue, 16 Aug 2022 15:11:55 +0530 Charan Teja Kalla <quic_charante@quicinc.com> wrote:

> Could you please drop this from mm tree. I will have to raise PATCH V4
> here.

Please just go ahead and send the v4.

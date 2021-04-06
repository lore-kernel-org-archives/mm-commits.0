Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEB1C433ED
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 07:12:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 789B5613AD
	for <mm-commits@archiver.kernel.org>; Tue,  6 Apr 2021 07:12:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238450AbhDFHNE (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 6 Apr 2021 03:13:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238014AbhDFHNE (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Tue, 6 Apr 2021 03:13:04 -0400
Received: from gimli.rothwell.id.au (gimli.rothwell.id.au [IPv6:2404:9400:2:0:216:3eff:fee1:997a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AFEC06174A
        for <mm-commits@vger.kernel.org>; Tue,  6 Apr 2021 00:12:56 -0700 (PDT)
Received: from authenticated.rothwell.id.au (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.rothwell.id.au (Postfix) with ESMTPSA id 4FDzJ10YXBzyNq;
        Tue,  6 Apr 2021 17:12:48 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rothwell.id.au;
        s=201702; t=1617693171;
        bh=HZuW4sNs5cauus4QaFSImnU98f8lzAdbFYwZeY22FJI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cTgfaYAyM6YzLNka5kV+EcMEjfRtM1wrOTBcIw8rJ6DhqRxNtgQa+9ci8Xw2oiu3T
         6h0QVtmILD+DktDKnaQyfyQW1ZGJzqkJb6Ecz8hzKQlzGUX5YLYTk4DTyYo8AC802h
         Noykod7UUKsL2Htm0VMYu3JCA2GIDAnG7ys+Lkyn76PwISOHtDAbvBxS/W3+NtPyEt
         7zskY1K18RE+QmjSGwhg+PtQsCHTaKRUrK4Ak6nBjzVBWqdRKQQvqh3hPu+xV4bdAu
         olFFJv6qrN5JVt6miL/iYnmgD3sHwg9KUdNANQOS937vmXFeEEujf6imRt6QeHic0g
         29sAle+moPHCQ==
Date:   Tue, 6 Apr 2021 17:12:46 +1000
From:   Stephen Rothwell <sfr@rothwell.id.au>
To:     akpm@linux-foundation.org
Cc:     alexey.skidanov@intel.com, alexs@kernel.org,
        mm-commits@vger.kernel.org, sfr@canb.auug.org.au,
        sjhuang@iluvatar.ai, unixbhaskar@gmail.com
Subject: Re: +
 lib-genalloc-add-parameter-description-to-fix-doc-compile-warning.patch
 added to -mm tree
Message-ID: <20210406171246.4a27320c@elm.ozlabs.ibm.com>
In-Reply-To: <20210406022237.xdgRw6JUz%akpm@linux-foundation.org>
References: <20210406022237.xdgRw6JUz%akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi all,

On Mon, 05 Apr 2021 19:22:37 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: lib/genalloc: add parameter description to fix doc compile warning
> has been added to the -mm tree.  Its filename is
>      lib-genalloc-add-parameter-description-to-fix-doc-compile-warning.patch

Added to linux-next today.

-- 
Cheers,
Stephen Rothwell

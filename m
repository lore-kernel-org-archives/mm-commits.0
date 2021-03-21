Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3E47C433C1
	for <mm-commits@archiver.kernel.org>; Sun, 21 Mar 2021 21:39:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 65D3861937
	for <mm-commits@archiver.kernel.org>; Sun, 21 Mar 2021 21:39:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbhCUVij (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Sun, 21 Mar 2021 17:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbhCUVia (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Sun, 21 Mar 2021 17:38:30 -0400
X-Greylist: delayed 383 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 21 Mar 2021 14:38:28 PDT
Received: from gimli.rothwell.id.au (gimli.rothwell.id.au [IPv6:2404:9400:2:0:216:3eff:fee1:997a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B2F5C061574
        for <mm-commits@vger.kernel.org>; Sun, 21 Mar 2021 14:38:28 -0700 (PDT)
Received: from authenticated.rothwell.id.au (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.rothwell.id.au (Postfix) with ESMTPSA id 4F3W6d3Gfrzytm;
        Mon, 22 Mar 2021 08:31:53 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rothwell.id.au;
        s=201702; t=1616362314;
        bh=QjIE78zd4THc5uDXvI4fP3Wkpa/+nCQd82u0ByE/B8U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DGqWdWDD5urZbXWRDd3TyIhpYWAZDeKiTgOZhI+MHvnN7cuct0m5PvBaGVkiqvHJR
         lUYVmNQCut3cGwxc8cHKFolJIdp7Q3DEo3Hf5ZkcNdeRewKVl7d5MocANjA/450oii
         L8B3IRAQGJ0FLuNdta8axhpQ/oT9gQIo59jp4xix/F+Gdaw5aWT1u16chxzlfNnAyi
         GTjx2BdlZVZkD+zjui/ON5d7MYxqNqfohVAm0nrpZu813sFz95jcm6dGGXKl34N86F
         jMEkbsw5xsaGrPhmJWSj7cj+vGz+MQJkQatSPz0xZwaUZBp/pQ1JO9ecAajTfgWoyQ
         ExcmOhV5K2XkA==
Date:   Mon, 22 Mar 2021 08:31:52 +1100
From:   Stephen Rothwell <sfr@rothwell.id.au>
To:     akpm@linux-foundation.org
Cc:     colin.king@canonical.com, mm-commits@vger.kernel.org,
        npiggin@gmail.com, sfr@canb.auug.org.au
Subject: Re: + mm-vmalloc-hugepage-vmalloc-mappings-fix.patch added to -mm
 tree
Message-ID: <20210322083152.1659cef0@elm.ozlabs.ibm.com>
In-Reply-To: <20210319231051.Zh1bITVQj%akpm@linux-foundation.org>
References: <20210319231051.Zh1bITVQj%akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

Hi all,

On Fri, 19 Mar 2021 16:10:51 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: [next] mm/vmalloc: fix read of uninitialized pointer area
> has been added to the -mm tree.  Its filename is
>      mm-vmalloc-hugepage-vmalloc-mappings-fix.patch

Added to linux-next today.

-- 
Cheers,
Stephen Rothwell

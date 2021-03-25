Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_RED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01245C433C1
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 21:19:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D6461A3C
	for <mm-commits@archiver.kernel.org>; Thu, 25 Mar 2021 21:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbhCYVTT (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 25 Mar 2021 17:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhCYVSt (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Thu, 25 Mar 2021 17:18:49 -0400
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B48EC06174A
        for <mm-commits@vger.kernel.org>; Thu, 25 Mar 2021 14:18:49 -0700 (PDT)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4F5ydd0VT9z9sW4;
        Fri, 26 Mar 2021 08:18:45 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1616707127;
        bh=InQSZhwksIVI1KGIGhxLB/Nj3VHyerp6tUXXvbGEN+s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KxXdzJ5yp84AnW1NEgbdxdCmIfVzR5a8ouGr6X4h60YdQih268xzPYzGZpQbiSK2V
         QM+PZRpWSsHC5RB1XDSVhL/s0R2kQZReuQ7TzFZ/I0m+JtdBgmcTM7ixlHK9RpHPZk
         aeB/sckHlWKu8VtHHJNLcA+ZsRClKT4aQbUx7+RPvPZ//5dbmGrLCIlvNelPqB2De2
         DlMHjVD5szY/iDnL/K1u4HtfxH1JTxFEzj+yA2/AsLwP4501GpYuEPTIr57KmEQZ3T
         I18YlmFlorRXzoaZ7MR7NYXGeEzP6NUMyLTNffXn3BkBgEbQtMgAQXxMJB+0PGmiYu
         5N/hcmXOygOqw==
Date:   Fri, 26 Mar 2021 08:18:43 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, willy@infradead.org, vbabka@suse.cz,
        mhocko@suse.com, liushixin2@huawei.com, wangkefeng.wang@huawei.com
Subject: Re: + mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch added
 to -mm tree
Message-ID: <20210326081818.4ea7f4cf@elm.ozlabs.ibm.com>
In-Reply-To: <20210324224300.eRVlM%akpm@linux-foundation.org>
References: <20210324224300.eRVlM%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/fmBcryNY=y.qQo6q_PqeOjz";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/fmBcryNY=y.qQo6q_PqeOjz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 24 Mar 2021 15:43:00 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm, page_alloc: avoid page_to_pfn() in move_freepages()
> has been added to the -mm tree.  Its filename is
>      mm-page_alloc-avoid-page_to_pfn-in-move_freepages.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/fmBcryNY=y.qQo6q_PqeOjz
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmBc/jMACgkQAVBC80lX
0GzlxQf/aMgCuSiRfWoW23SE1xd8IsRLZkcAQ0IBawHUx8q3nET0LuwPvrHO/B2+
huV8mhLd3eTlIgO4shAgTJf50XzmMrgJ0aISaXafkuMLyUtbA/jtJBbFxcm0VWio
+th+L0L6fCfYWzdq3RMaJ40ZvT4i8CmqM+Gfq/GScbK3CXbD8pJiurXeAqIYfRLA
ZiS7dWMmaWdDmAUkNVgDsqqtcOIhMOUJ9CUMbelQlIoht2tHmPlVHCM/CDdDtbP+
de3Qamaur4uQzSD3u38ynQ4LNSGMZW7i/CN/KETT3Ttxi8+3HKohNBnGhFGaQis/
ZxhKx8ET1v3gXyaaic0GeB2jDTJ/UA==
=ELqn
-----END PGP SIGNATURE-----

--Sig_/fmBcryNY=y.qQo6q_PqeOjz--

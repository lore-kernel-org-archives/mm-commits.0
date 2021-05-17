Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59E5FC433ED
	for <mm-commits@archiver.kernel.org>; Mon, 17 May 2021 22:43:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BEC961209
	for <mm-commits@archiver.kernel.org>; Mon, 17 May 2021 22:43:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239987AbhEQWoh (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 May 2021 18:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344020AbhEQWoe (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 May 2021 18:44:34 -0400
X-Greylist: delayed 74 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 17 May 2021 15:43:17 PDT
Received: from gimli.rothwell.id.au (gimli.rothwell.id.au [IPv6:2404:9400:2:0:216:3eff:fee1:997a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F78DC06175F
        for <mm-commits@vger.kernel.org>; Mon, 17 May 2021 15:43:17 -0700 (PDT)
Received: from authenticated.rothwell.id.au (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.rothwell.id.au (Postfix) with ESMTPSA id 4FkZ0b5wj6zyxx;
        Tue, 18 May 2021 08:43:11 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rothwell.id.au;
        s=201702; t=1621291392;
        bh=DlQBwsvKQd+bPttJtuhnELAm5TGFQdpnsRnhR0f/WZU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qjnH2r+OvySsyE926blYaaziz8reUqokF0Ll+CgjWI3ZdvAsARvYGwEXxBPtJYvwV
         iWR96pff1g6uk1h7WoQitmxwB8B0p1dHfqEhc5896PeHOgeiEbKvdOJ3xcwYAxnx5m
         DTkU/JS2h5G2XQXVhvBDJqT5SPgXRV2dLdfnvrIJcj3w01d5ZjFgOTjdHaHMMW3bls
         l6RehOpxGgytkKnhtFsH4RwFc5bJqDx8AaZFo+y9Ec5GGo2B1WSghaOKav+6mQ+txN
         j4dm1XbXnBNC/2Dj29gk4rjs6qbpUP5tdfp56FGFZ39GZ4qPwpzUrOQZlZE+7jJWl9
         5xw7G5okV8vJA==
Date:   Tue, 18 May 2021 08:43:10 +1000
From:   Stephen Rothwell <sfr@rothwell.id.au>
To:     akpm@linux-foundation.org
Cc:     mgorman@techsingularity.net, mm-commits@vger.kernel.org,
        sfr@canb.auug.org.au
Subject: Re: +
 mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch added to
 -mm tree
Message-ID: <20210518084310.2602ad09@elm.ozlabs.ibm.com>
In-Reply-To: <20210514210235.MKMqVvmJa%akpm@linux-foundation.org>
References: <20210514210235.MKMqVvmJa%akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/mtGmeiKZJ=4wvyArPgSaDAg";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/mtGmeiKZJ=4wvyArPgSaDAg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 14 May 2021 14:02:35 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm/page_alloc: split per cpu page lists and zone stats -fix
> has been added to the -mm tree.  Its filename is
>      mm-page_alloc-split-per-cpu-page-lists-and-zone-stats-fix.patch

Added to linux-next today.
--=20
Cheers,
Stephen Rothwell

--Sig_/mtGmeiKZJ=4wvyArPgSaDAg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCi8X4ACgkQAVBC80lX
0GwBawf/SBVCv71BDoEu8J+tknt/6Ly5v8UV6V7tUZDcq0lD/MVmuwL98+xDsbst
EAVSDSUFD7zPsqxlAwELRDOaTVmuVQRR2OmJpC5L8zjyE+wixWuoQEkWFwWsQhSa
k6CkZqFbsb8yMZ8hXzuVwZqlaKte9HWx7c3MmAukfIxNaKxGEq/Sc6dOc3VPzmco
eTSh77aajgbUcv8XFMkaV8hlNm9UdDx6aZvDeMqprxuOHI6thZp4zKyUN8F3vjKY
1pXz8grPDPhhe7nnDldXC7dXYCkOTHpZwiihsg8MLc5OKOkFf7d/8FImEr/oqTgu
58ITtwdCXwNivAqobUGMm2A31yJt3Q==
=fmlR
-----END PGP SIGNATURE-----

--Sig_/mtGmeiKZJ=4wvyArPgSaDAg--

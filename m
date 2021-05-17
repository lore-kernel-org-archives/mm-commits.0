Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87A3FC433ED
	for <mm-commits@archiver.kernel.org>; Mon, 17 May 2021 22:48:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 652DF61261
	for <mm-commits@archiver.kernel.org>; Mon, 17 May 2021 22:48:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344069AbhEQWuG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Mon, 17 May 2021 18:50:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238582AbhEQWuG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Mon, 17 May 2021 18:50:06 -0400
Received: from gimli.rothwell.id.au (gimli.rothwell.id.au [IPv6:2404:9400:2:0:216:3eff:fee1:997a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C3C2C061573
        for <mm-commits@vger.kernel.org>; Mon, 17 May 2021 15:48:49 -0700 (PDT)
Received: from authenticated.rothwell.id.au (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.rothwell.id.au (Postfix) with ESMTPSA id 4FkYzC5tW4zyNq;
        Tue, 18 May 2021 08:41:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=rothwell.id.au;
        s=201702; t=1621291322;
        bh=EU5mvizf2/Om8SxtE15UFPlT0jm4ikZJGhNw4myVzq0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=CIifD8zYXxAFPg7hZpOm06VIjEbRhd4PV8QFce9+sRfi3MLXrOGddBCkJcjTOtsX5
         oN4BgUGVIqPvEGRQdrFLs8dUuTAyhYPgIZJlJDegGWy+VHNfkkzqTJvqOQJfi2ltVB
         PU/2NV1EwiyeSILuC07NRM+nrLAaX4VP62lonr+9+0y616NGSu2oJwNhgHk5OFS1aj
         TeWRM80zZgR2wXFKtxnM7cdd8kV1OoAGdeoFh3mtFsvBh9rIGVbgaOrW+9PQ61VH36
         6vss6LlvpnkI4+rhi5L3jL3eT8vFDFnwizl03IjAdzqyf/8iw3tyakhhay1qFFUmPM
         6GuO/MdeCx7HA==
Date:   Tue, 18 May 2021 08:41:58 +1000
From:   Stephen Rothwell <sfr@rothwell.id.au>
To:     akpm@linux-foundation.org
Cc:     aneesh.kumar@linux.ibm.com, christophe.leroy@csgroup.eu,
        joel@joelfernandes.org, kaleshsingh@google.com,
        mm-commits@vger.kernel.org, mpe@ellerman.id.au,
        naresh.kamboju@linaro.org, npiggin@gmail.com, sfr@canb.auug.org.au
Subject: Re: +
 mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fix.patch
 added to -mm tree
Message-ID: <20210518084158.1dba5371@elm.ozlabs.ibm.com>
In-Reply-To: <20210514220959.IXjn-Z0ga%akpm@linux-foundation.org>
References: <20210514220959.IXjn-Z0ga%akpm@linux-foundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/_2UqihDm=+c_C+utjwLYN2E";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/_2UqihDm=+c_C+utjwLYN2E
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 14 May 2021 15:09:59 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache=
-flush-fix
> has been added to the -mm tree.  Its filename is
>      mm-mremap-use-range-flush-that-does-tlb-and-page-walk-cache-flush-fi=
x.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/_2UqihDm=+c_C+utjwLYN2E
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmCi8TYACgkQAVBC80lX
0GwRrQf+MIEL5HqiAjgDAtgwwkmUQwvTvBVihfm5jkRs4eWFw2a+uvzOFG+V0PFJ
PiKnjd61cta5bm2DM+SGBjjtltdpIg1T3s6VnSeNwWFUwBZPidBvl2SCluky2gSC
iX79fkZimiDdKFnxQXMs0FxEhick3AJ70aUemfqxti/3UBkjstiBTM04jD2AmBwJ
5PEkteawFFM/Uo98sqi5RMVNjzTv3vRni7IBaFhRcuo/LxkxUEQzJuoQ3shHHc60
pimE4S3nXapPhzk8UpXW6iV6dnmxy0d1QkKP9wuvkRs4TbUpguGput9qz+9tCfvM
xNgs2/WB2Zc7NUmyFguJPOLUgsbpEw==
=//k4
-----END PGP SIGNATURE-----

--Sig_/_2UqihDm=+c_C+utjwLYN2E--

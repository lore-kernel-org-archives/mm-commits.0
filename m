Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E422BC433E0
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 03:28:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94B3D22EBE
	for <mm-commits@archiver.kernel.org>; Wed, 13 Jan 2021 03:28:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727222AbhAMD1x (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 12 Jan 2021 22:27:53 -0500
Received: from ozlabs.org ([203.11.71.1]:47013 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbhAMD1x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 12 Jan 2021 22:27:53 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DFtCy4BZlz9s24;
        Wed, 13 Jan 2021 14:27:10 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1610508431;
        bh=pbL4G1M1sdeNu1mmL9HiHwxAaMxouR3pYZo3R3JY8ZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tpLbBVH91ldB3pBljmpeBSe/3UAiVf6XeGeIdIaiy5ccO73sAIsRRsalRpbwvZDmr
         bi30ywcLGpt5kVFA8zrJ34zQWXugwqV8AVJn2f8TfVgo6DwwcbCzoh3VRaD/EyCKjg
         WyL0bTGe3UXmm8j6IHLTs7z0Ynf/pOjiR1c1cMwSmWE0Zvffk7QD38Fj0HIGr4Z8gY
         g8ei+huMFwbiNKM1F3uK2pXny8dqh+VBNGyt/cQCqLHnzOKVKxf3xwJam+C9R1oHCL
         y6gFblk6eY0VWCxrLv0vSYAHuoVsSDPgJXLq0HQ1IUKTvQWElY9Al0XwT6/NNdBrl2
         80at7Dt0l9jIg==
Date:   Wed, 13 Jan 2021 14:27:09 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     arnd@arndb.de, elver@google.com, georgepope@android.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        natechancellor@gmail.com, ndesaulniers@google.com
Subject: Re: + ubsan-disable-unsigned-overflow-check-for-i386.patch added to
 -mm tree
Message-ID: <20210113142709.6407bdc3@canb.auug.org.au>
In-Reply-To: <20210112215505.-EdFgAiis%akpm@linux-foundation.org>
References: <20210112215505.-EdFgAiis%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/d2R6tsl=MoTdeoTc1Y/p_pR";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/d2R6tsl=MoTdeoTc1Y/p_pR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 12 Jan 2021 13:55:05 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: ubsan: disable unsigned-overflow check for i386
> has been added to the -mm tree.  Its filename is
>      ubsan-disable-unsigned-overflow-check-for-i386.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/d2R6tsl=MoTdeoTc1Y/p_pR
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/+aI0ACgkQAVBC80lX
0GxjpQf+NEeqBvuGoK7WsC+cTha76aWTmjdkiwFjkyFYPtAamfFCfvfFg2pKW8wD
xH0fiW/GdS76vFiLtcQy2acgrmz4tQGYYiFT/m4rnvYSQ5PzSkIhG0w5zmD4SgOu
gj7xclBTtb+ZKHlm8QQ86rRDi75ZmP5fCEMW3kHOoLQKLn74ceIUJheLGfTqdMxg
f81lDft37DARBse7Y2iKbRccivTWcuoD91XqA1L622H+c3Wbw4kTeiCnG5ooKqSG
FhfLlqtWo/7HQ7Tnn1v181s+OeoE60FfMa+ZFzz3h2wa9mHi8XaxFuTdqchbHFHY
lKcGqXXiDjc3srbZ6PD92iGY977DYQ==
=SXi+
-----END PGP SIGNATURE-----

--Sig_/d2R6tsl=MoTdeoTc1Y/p_pR--

Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C88AAC433DB
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 20:21:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6DB4C64E4A
	for <mm-commits@archiver.kernel.org>; Tue,  2 Feb 2021 20:21:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhBBUV1 (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 2 Feb 2021 15:21:27 -0500
Received: from ozlabs.org ([203.11.71.1]:38571 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231667AbhBBUTU (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 2 Feb 2021 15:19:20 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4DVbjn428tz9tl7;
        Wed,  3 Feb 2021 07:18:37 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1612297118;
        bh=F0rANMMup8JMag/Ig+6spA9HbFPdDxEelkhWk03Fq+c=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Lx31BvkKmY4q5TLUvHF/mgLCjOnpeAcXjlykTXmZdNWb41fRPOZ1XptB1vjUIlbdb
         rOz8qKN/WDTRRl3bwpOg/DHN5eX/cJkITwHUBgkwWS0OeysavtWPkF6LeoEX0igqcF
         WLbne/ElYfIYRtO1c1gyJHcW5ZcTs9cYScLFXByL67DCUByZeYEgHA/RuJ1dNF07OB
         fCs6e8eahEwsFBWiUeYyXMKGmvUxfkUf0T6kExCe0n6BFdgc2rvBj3WDQdIUNLZQeX
         QUAJraGaRDC1MjCpywtUg7snpfHe1ySsr0UraWoVz8Dr1csjeO6T8/Fm//4Hl+2tgR
         /tWqzmO/E6y/Q==
Date:   Wed, 3 Feb 2021 07:18:36 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     lkp@intel.com, mm-commits@vger.kernel.org,
        pasha.tatashin@soleen.com
Subject: Re: + mm-gup-do-not-migrate-zero-page-fix.patch added to -mm tree
Message-ID: <20210203071836.1a6c21f9@canb.auug.org.au>
In-Reply-To: <20210202193438.M1pjE6lYJ%akpm@linux-foundation.org>
References: <20210202193438.M1pjE6lYJ%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/OLhQGP6EVP4mt=OlvuQnOWe";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/OLhQGP6EVP4mt=OlvuQnOWe
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 02 Feb 2021 11:34:38 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm-gup-do-not-migrate-zero-page-fix
> has been added to the -mm tree.  Its filename is
>      mm-gup-do-not-migrate-zero-page-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/OLhQGP6EVP4mt=OlvuQnOWe
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmAZs5wACgkQAVBC80lX
0GxDJgf9EX9OGRouN6P+NF1gdUT6w3tVfXjfRaKh1Q4X3UwujWSNUy9DP2t+ARg5
haLKtl1ZGeHKDYhEE9STcWu5toUsifk1GKIg9TBDT6lH83eoFzNmg6ZOOCHyVlfj
O0GsMAdtGsfBfbaaW6STkD9VxQ1lc6wydq7rDOncXHF+WXLpE0d3I2XRBG5rD6f4
/H1qgljCCCkYJR5/7xIJbhdFrP3SUJX70A58WQfochw4BcSrwtSY8ltQZORJR40c
F50xR6CRjLy26vQ5BX7jcPiUPnj4xIuwcP9XGkUTw4e8AiFBCv+3+H85oDQQylgO
58W8qUCWDmQPhh44hCD0u6YcmGLIdA==
=SENW
-----END PGP SIGNATURE-----

--Sig_/OLhQGP6EVP4mt=OlvuQnOWe--

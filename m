Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4493AC47082
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 09:25:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1F4DA61263
	for <mm-commits@archiver.kernel.org>; Tue,  8 Jun 2021 09:25:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230382AbhFHJ0y (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Tue, 8 Jun 2021 05:26:54 -0400
Received: from bilbo.ozlabs.org ([203.11.71.1]:57395 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230385AbhFHJ0x (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Tue, 8 Jun 2021 05:26:53 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FzlFR2fBxz9s1l;
        Tue,  8 Jun 2021 19:24:59 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1623144299;
        bh=yp8hDBNWBb+LLRZCc9W4MSUgAX98bQdHfUqBXkoNetQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a0V0G/yOw+1HMrOsNY7xQxTpELqJcSVI4k2jb/eehN2SdS6aFMBlcr5RfT0iCZ05b
         owZG6h4xyQ8L1sh+GEzp3exUefgF8l34uQWT7jlk8r4CEApv2YFAOg1kWXsAYE0FZ8
         uX3Vgr5gRtwkUYGSzboQ968URCMD/uL8cNNIpoZXZvRI8CpufTR2xY/J9Y+wtWmNnw
         KLw4gXv6A2U3RiIetS/zvg18HObguYcWa05VCZSyqJj/8Vtp6QeIjuyqISNEajG4O9
         iKVIDrarZCOurYCA1MoohFKP8H8YQJ3Z/InK9ho1f1f7xEaxqWBouigArq2twsQ19z
         VhAibVtZe07pg==
Date:   Tue, 8 Jun 2021 19:24:56 +1000
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, npiggin@gmail.com
Subject: Re: +
 lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch added to -mm
 tree
Message-ID: <20210608192456.0c9040ff@canb.auug.org.au>
In-Reply-To: <20210608041548.qp54AiPBy%akpm@linux-foundation.org>
References: <20210608041548.qp54AiPBy%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/a8i7CDR.0J3VdSJgazpGx7R";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/a8i7CDR.0J3VdSJgazpGx7R
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 07 Jun 2021 21:15:48 -0700 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix
> has been added to the -mm tree.  Its filename is
>      lazy-tlb-introduce-lazy-mm-refcount-helper-functions-fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/a8i7CDR.0J3VdSJgazpGx7R
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmC/N2gACgkQAVBC80lX
0Gz6fwgAorV6c9C0N6fAbHsPIfr7d/7kC3b5pWy223PJe2DymSA4sc2wcut2Zia/
5J2FiVVPJfKRqseHNFEZi1N1sHe/B8eBDvWQRwcmRzABsTxQRkKQtFWfbp5GhmZd
0oTAd+zvTnSZQ/6k9RB9fcWxqFRvAg1jE4P9gMys86GB0DAJ9YyOsG7Zcc1NawVq
v/BrZoZo0yhlkKIst/PIDFYo2omBzHUlVRSznccNmH5T8Ukd86mXA+WTWhMeIYOG
Bi+URrD3TbZqFgjZ5hLbSCrFk6ZpKC3+PIDG12tH3DeZyHnC1x15rHbrS/ESTc5Y
OHTyIqhrhwShTOEPQrZfMhpqdwtkpA==
=CrEh
-----END PGP SIGNATURE-----

--Sig_/a8i7CDR.0J3VdSJgazpGx7R--

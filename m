Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA1D3C433FE
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:34:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 585ED2229C
	for <mm-commits@archiver.kernel.org>; Thu,  3 Dec 2020 21:34:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbgLCVeC (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Thu, 3 Dec 2020 16:34:02 -0500
Received: from ozlabs.org ([203.11.71.1]:40803 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728252AbgLCVeB (ORCPT <rfc822;mm-commits@vger.kernel.org>);
        Thu, 3 Dec 2020 16:34:01 -0500
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4Cn8G42TTkz9sSf;
        Fri,  4 Dec 2020 08:33:16 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1607031199;
        bh=2SDUYgleWp3BW+wFrxjsUMhCIgFEFardpokeZL67Oj0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tyTSUn2fl1YxKB8zBh6dir02tNq4w/IKV7Rs1BFsCS3V97gTfKsHMVg71G9WFKz6F
         tLE0reupnpgB94FsAnmj+m9mq6rXxPwySXUqVfuxes4+cy/gG8IMtPNBU7426ml1aM
         D2ue2x0hxZsAwBfQgsEh9QA+VDaWjT7rLPvda9RxwsvdTXonq69d9BgNopTFO2R4FK
         09wJnoZriC5KUXsJKm6kQjkftuzqy4PS4QytV4SoZOqJDFSjd51jht8cVb072O0YdG
         rtoZUGri+S5ERRrb0CcET9sxdYh9zL/v8Kb7N9hN8v3+Y16h6/2l53qZIi6QmvkNdB
         6axNpyTt8EO9g==
Date:   Fri, 4 Dec 2020 08:33:15 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     aarcange@redhat.com, bhe@redhat.com, cai@lca.pw, david@redhat.com,
        lstoakes@gmail.com, mgorman@suse.de, mhocko@kernel.org,
        mm-commits@vger.kernel.org, rppt@linux.ibm.com, vbabka@suse.cz
Subject: Re: +
 mm-refactor-initialization-of-stuct-page-for-holes-in-memory-layout-fix.patch
 added to -mm tree
Message-ID: <20201204083315.7982cd36@canb.auug.org.au>
In-Reply-To: <20201203202649.eYvGSeY0K%akpm@linux-foundation.org>
References: <20201203202649.eYvGSeY0K%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/i8G1j.P08l9/MJUuRcQmw8J";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/i8G1j.P08l9/MJUuRcQmw8J
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Thu, 03 Dec 2020 12:26:49 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: fixup for "mm: refactor initialization of stuct page for ho=
les"
> has been added to the -mm tree.  Its filename is
>      mm-refactor-initialization-of-stuct-page-for-holes-in-memory-layout-=
fix.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/i8G1j.P08l9/MJUuRcQmw8J
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl/JWZsACgkQAVBC80lX
0GwVkAgAoHyaywViS9Kf8jkeMxoN/GxY8jV6woIjKZjjUVlkOiWa103gpiEbZQrz
HiekJnsqjqwNhsLDHA0Ifbk89ueMefzOflF7JQyn6zUM/CHcSwGcVC27Ob8TxBA3
32pHGhrvK0dLLCD0gJ6u5O9JXGUwJjWvcgi2PI34UJPCedVB16aHF68vzwq44z+E
UuFvVyF5ccMTw2cpa69e3fVxFiOM2AjRy5QZ89P1gb+80QrgnO2KcklQn45gnLIC
IhhSKnWCOeDlnS8/NfdUbBdVrFb6UrxAlVF99GX8janfq/DDT6Sj4HjkeJ6+oKPk
v85Ja0zgOXwX3qHS2PxzSpSw4Ft3nQ==
=2Nuq
-----END PGP SIGNATURE-----

--Sig_/i8G1j.P08l9/MJUuRcQmw8J--

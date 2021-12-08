Return-Path: <mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE7F3C433EF
	for <mm-commits@archiver.kernel.org>; Wed,  8 Dec 2021 05:46:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230423AbhLHFuV (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 8 Dec 2021 00:50:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbhLHFuU (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 8 Dec 2021 00:50:20 -0500
Received: from gandalf.ozlabs.org (gandalf.ozlabs.org [IPv6:2404:9400:2:0:216:3eff:fee2:21ea])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A44C061574
        for <mm-commits@vger.kernel.org>; Tue,  7 Dec 2021 21:46:49 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4J85lC59qJz4xZ1;
        Wed,  8 Dec 2021 16:46:47 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canb.auug.org.au;
        s=201702; t=1638942408;
        bh=XYU1iV0dPaMB+v6PmxaH+/DVhnTWICDIIroVEnWEfX4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=shIS53TN6w86a4Wer+dtcJvGPRt8jy5aYaLOUfUZe2Q/O+yl5jgglGdNPhFBvxXZk
         6Qjoan0BSN+ifkZ8LRAIV4yXfkoP2Ou0OIrRVQ0xxtGhD/hVyaWM9NisE1FrGy81BC
         ewNf86g//8BplKEp2HwcmK2xmDFwxNY8E1HA5BxitFGB9kQz/e3m09TTjb0omM6T04
         /Vsz8yC1ftBDwUOxkcta9eGy8F9htAwjqrm4UUGc5bQlCn0FN8WPnGv0Om6AIvnrXv
         lK7p1M6809wd+sqbH93AsKx1zkcaVEjXsvH7tqBc6Vug7rdrOj3xvRwcEPqCRlfnx2
         49bSKmYkOGdaA==
Date:   Wed, 8 Dec 2021 16:46:45 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     arnd@arndb.de, ccross@google.com, ebiederm@xmission.com,
        keescook@chromium.org, mm-commits@vger.kernel.org,
        peterx@redhat.com, peterz@infradead.org, surenb@google.com,
        vbabka@suse.cz, viro@zeniv.linux.org.uk, willy@infradead.org,
        yuzhao@google.com
Subject: Re: + mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh.patch
 added to -mm tree
Message-ID: <20211208164645.51b7804e@canb.auug.org.au>
In-Reply-To: <20211208001138.pZrzcRX8_%akpm@linux-foundation.org>
References: <20211208001138.pZrzcRX8_%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/EILS_j/EZWvReOVBlfNhQax";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_/EILS_j/EZWvReOVBlfNhQax
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 07 Dec 2021 16:11:38 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm: move tlb_flush_pending inline helpers to mm_inline.h
> has been added to the -mm tree.  Its filename is
>      mm-move-tlb_flush_pending-inline-helpers-to-mm_inlineh.patch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_/EILS_j/EZWvReOVBlfNhQax
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAmGwRsUACgkQAVBC80lX
0Gwewgf/UnrPgeoh2ivRhIForzBclU5TkYY+3eKlfb3/TAQO9JNcZHfjHEf7de/C
TkfcYs0rc7EdYSqX6sGEGlvgRalUIaial1D6iW+AKc4iLY8mNsitdEVQP6NKrrNC
mpcONY+MSDkUTiuqxS8koRNN95SXbTFdytIKC5K/JcCSYAaO5OmtSJplil8a0/Ze
YZYm7t/h/gpYkbdxzXvWA1ZfaSj/otWlRj0StW589v/g6DqoQY1F1SPgp1ZkKyyy
gClVwixeJagnViQgj3nTPnEMl1rSreAzXl0ky9IZpr24OCDsV5VldA48k79e9XuE
4eAhXPHacGbEM5reUFXZrHGC1LyZFQ==
=xZ2s
-----END PGP SIGNATURE-----

--Sig_/EILS_j/EZWvReOVBlfNhQax--

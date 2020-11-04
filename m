Return-Path: <SRS0=Jp7A=EK=vger.kernel.org=mm-commits-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80FBEC2D0A3
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 21:09:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DEE2B2080D
	for <mm-commits@archiver.kernel.org>; Wed,  4 Nov 2020 21:09:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=canb.auug.org.au header.i=@canb.auug.org.au header.b="pX+pKns+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730735AbgKDVJG (ORCPT <rfc822;mm-commits@archiver.kernel.org>);
        Wed, 4 Nov 2020 16:09:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726969AbgKDVJG (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Nov 2020 16:09:06 -0500
Received: from ozlabs.org (bilbo.ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BEBC0613D3
        for <mm-commits@vger.kernel.org>; Wed,  4 Nov 2020 13:09:06 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4CRK5P03tRz9sPB;
        Thu,  5 Nov 2020 08:08:56 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=canb.auug.org.au;
        s=201702; t=1604524143;
        bh=+a9xi3WRXTZfUuptILM5EFZ+KyTU2uiiGIHLB6gpcjA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pX+pKns+KKgOvNmXOuG1ptkPiahK12XfqdUjtBYuYqRjwRdVHzDNBP09CjK0ptIFJ
         a3C3TjFcaNoUlzatN2GiTKkdV98YOj+EoayvyFe+t6iPWpZdGRd9WP2f2g7+A83p2c
         asMsjoIHaESKOtey+7yvR3QezbuOIsqFGUNXfHGhnSkAa5pNGqmdC0WJON2dgw+vup
         KiDnGT/upR3m+KseCSahHZSq+SCDrV9bOqRuwopbn3T370qNR5lrSkMA+aoaJBlvE8
         x6GDf+kR/uUSWPxCGXnqXXxJhGUJqTllH43WM4l7c0cQdXq+NoAsfJBRVl+CynGINL
         /mPF4yHwkLS+w==
Date:   Thu, 5 Nov 2020 08:08:56 +1100
From:   Stephen Rothwell <sfr@canb.auug.org.au>
To:     akpm@linux-foundation.org
Cc:     mm-commits@vger.kernel.org, vishal.l.verma@intel.com,
        tony.luck@intel.com, tglx@linutronix.de, rdunlap@infradead.org,
        paulus@samba.org, mpe@ellerman.id.au, lkp@intel.com,
        joao.m.martins@oracle.com, hch@lst.de, hch@infradead.org,
        fenghua.yu@intel.com, benh@kernel.crashing.org,
        dan.j.williams@intel.com
Subject: Re: +
 mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports.patch
 added to -mm tree
Message-ID: <20201105080856.4d024450@canb.auug.org.au>
In-Reply-To: <20201104091420.IrRxu%akpm@linux-foundation.org>
References: <20201104091420.IrRxu%akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_//21zD2kPYZictGgh39LRkth";
 protocol="application/pgp-signature"; micalg=pgp-sha256
Precedence: bulk
Reply-To: linux-kernel@vger.kernel.org
List-ID: <mm-commits.vger.kernel.org>
X-Mailing-List: mm-commits@vger.kernel.org

--Sig_//21zD2kPYZictGgh39LRkth
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 04 Nov 2020 01:14:20 -0800 akpm@linux-foundation.org wrote:
>
> The patch titled
>      Subject: mm: fix phys_to_target_node() and memory_add_physaddr_to_ni=
d() exports
> has been added to the -mm tree.  Its filename is
>      mm-fix-phys_to_target_node-and-memory_add_physaddr_to_nid-exports.pa=
tch

Added to linux-next today.

--=20
Cheers,
Stephen Rothwell

--Sig_//21zD2kPYZictGgh39LRkth
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEENIC96giZ81tWdLgKAVBC80lX0GwFAl+jGGgACgkQAVBC80lX
0GyG8wf/dGqRt2aZYo9d6V0XmU0mhPyR52TEn8pOpi6tAvAGgeqdpB4oelrLFNH6
LIG5EHzeOtfJkkupxqMILgmeGCVF+8jXS3trLiNT/oqLG8e5ScoBgdWTJSOWoSKw
za1VRx5KsbsucdvloKk0J6PNCbDs/g/4rBLeNRZ++gvkBg5u07HxS1BBNbmVhyqS
gnjpDZXKxXKpkReqesX/GGWVrYuavDWLOoYFKdGe50fB6fns3UxsDNIUnQTXYTAX
2AkZ2Xomju46NTL/Mr71ssk2hsjTFkkzxE5DOTzJjpEvuztRgSB27HbO0VGxorQd
yJENQaeXWyCoRo+jVgENC4T3i78vwg==
=9zpm
-----END PGP SIGNATURE-----

--Sig_//21zD2kPYZictGgh39LRkth--
